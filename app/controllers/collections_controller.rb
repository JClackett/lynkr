class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :sidebar_collections, only: [:index, :show, :new, :edit, :browse]




  # GET /collections
  # GET /collections.json
  def index
     if user_signed_in? 
     #show only root collections (which have no parent collections) 
      @collections = current_user.collections.roots
       
     #show only root files which has no "collection_id" 
     @links = current_user.links.where("collection_id is NULL").reverse   
    end
    @bottom_bar_header = "Dashboard"
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
    @links = @collection.links.reverse
    @collection_header = @collection.title.titleize
  end

  # GET /collections/new
  def new
    @bottom_bar_header = "New Collection"
   @collection = current_user.collections.new     
   #if there is "collection_id" param, we know that we are under a collection, thus, we will essentially create a subcollection 
   if params[:collection_id] #if we want to create a collection inside another collection 
       
     #we still need to set the @current_collection to make the buttons working fine 
     @current_collection = current_user.collections.find(params[:collection_id]) 
       
     #then we make sure the collection we are creating has a parent collection which is the @current_collection 
     @collection.parent_id = @current_collection.id 
   end
end

  # GET /collections/1/edit
  def edit
  end

  # POST /collections
  # POST /collections.json
  def create 
   @collection = current_user.collections.new(collection_params) 
   if @collection.save 
    flash[:notice] = "Successfully created collection."
      
    if @collection.parent #checking if we have a parent collection on this one 
      redirect_to browse_path(@collection.parent)  #then we redirect to the parent collection 
    else
      redirect_to root_url #if not, redirect back to home page 
    end
   else
    render :action => 'new'
   end
end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update
    respond_to do |format|
      if @collection.update(collection_params)
        format.html { redirect_to @collection, notice: 'Collection was successfully updated.' }
        format.json { render :show, status: :ok, location: @collection }
      else
        format.html { render :edit }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy 
   @collection = current_user.collections.find(params[:id]) 
   @parent_collection = @collection.parent #grabbing the parent collection 
  
   #this will destroy the collection along with all the contents inside 
   #sub collections will also be deleted too as well as all files inside 
   @collection.destroy 
   flash[:notice] = "Successfully deleted the collection and all the contents inside."
  
   #redirect to a relevant path depending on the parent collection 
   if @parent_collection
    redirect_to browse_path(@parent_collection) 
   else
    redirect_to root_url       
   end
end

  def browse 
    #get the collections owned/created by the current_user 
    @current_collection = current_user.collections.find(params[:collection_id])   
  
    if @current_collection
      @bottom_bar_header = @current_collection.title

    
      #getting the collections which are inside this @current_collection 
      @collections = @current_collection.children 
  
      #We need to fix this to show files under a specific collection if we are viewing that collection 
      @links = @current_collection.links
  
      render :action => "index"
    else
      flash[:error] = "Don't be cheeky! Mind your own collections!"
      redirect_to root_url 
    end
end

def share     
    #first, we need to separate the emails with the comma 
    email_addresses = params[:email_addresses].split(",") 
      
    email_addresses.each do |email_address| 
      #save the details in the Sharecollection table 
      @shared_collection = current_user.shared_collections.new
      @shared_collection.collection_id = params[:collection_id] 
      @shared_collection.shared_email = email_address 
    
      #getting the shared user id right the owner the email has already signed up with ShareBox 
      #if not, the field "shared_user_id" will be left nil for now. 
      shared_user = User.find_by_email(email_address) 
      @shared_collection.shared_user_id = shared_user.id if shared_user 
    
      @shared_collection.message = params[:message] 
      @shared_collection.save 
    
      #now we need to send email to the Shared User 
    end
  
    #since this action is mainly for ajax (javascript request), we'll respond with js file back (refer to share.js.erb) 
    respond_to do |format| 
      format.js { 
      } 
    end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection
      @collection = current_user.collections.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collection_params
      params.require(:collection).permit(:title, :user_id, :parent_id, :link_id)
    end
end
