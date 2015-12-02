class LinksController < ApplicationController
  before_action :set_link, only: [:update, :destroy, :favourite, :update_description]
  before_action :authenticate_user!
  before_action :sidebar_collections, only: [:index, :new, :favourites ]



  # GET /links
  # GET /links.json
  # Show all links the user created
  def index
    @links = current_user.links  
    @bottom_bar_header = "My Links"
  end

  # GET /links/new
  def new
    @bottom_bar_header = "New Link"
    @link = current_user.links.new     
    if params[:collection_id] #if we want to upload a file inside another collection 
     current_collection = Collection.find(params[:collection_id]) 
     @link.collection_id = current_collection.id 
    end    
end

  # POST /links
  # POST /links.json
  def create 
  @link = current_user.links.new(link_params) 

  if @link.save 
   flash[:notice] = "Successfully uploaded the link."
  
   if @link.collection #checking if we have a parent collection for this file 
     redirect_to browse_path(@link.collection)  #then we redirect to the parent collection 
   else
     redirect_to root_path
   end      
  else
   render :action => 'new'
  end
end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to links_path, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_description
  end

  # GET /favourites
  # List all favourited links

  def favourites
    @bottom_bar_header = "Favourites"
    @favourited_links =  Link.joins(:favourites).where( favourites: { user_id: current_user } )
  end

  # PUT /link/1/favourite
  #Method to assign like to link

  def favourite
    if Favourite.where(user_id: current_user.id, link_id: @link.id).present?
      @favourite = Favourite.where(user_id: current_user.id, link_id: @link.id)
      @favourite.first.delete
    else
      @favourite = @link.favourites.new(user: current_user)
      @favourite.save
    end 
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy 
  @link = current_user.links.find(params[:id]) 
  @parent_collection = @link.collection #grabbing the parent collection before deleting the record 
  @link.destroy 
  flash[:notice] = "Successfully deleted the file."
  
  #redirect to a relevant path depending on the parent collection 
  if @parent_collection
   redirect_to browse_path(@parent_collection) 
  else
   redirect_to root_url 
  end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = current_user.links.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:url, :description, :image_url, :user_id, :collection_id )
    end
end
