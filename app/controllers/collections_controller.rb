class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :sidebar_collections, only: [:index, :show, :new, :edit, :browse]
  respond_to :html, :json



  # GET /collections
  # GET /collections.json
  def index
     if user_signed_in? 
     #show only root collections (which have no parent collections) 
      @collections = current_user.collections.roots  
       
     #show only root files which has no "collection_id" 
     @links = current_user.links.where("collection_id is NULL").reverse   
    end
    @bottom_bar_header = "Collections + Links"
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
      if @collection.update(collection_params)
        redirect_to @collection
      else
        render :edit
     end
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy
    @collection.destroy
      redirect_to collections_url
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
