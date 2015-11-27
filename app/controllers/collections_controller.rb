class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :sidebar_collections, only: [:index, :show, :new, :edit]
  respond_to :html, :json



  # GET /collections
  # GET /collections.json
  def index
    @collections = current_user.collections
    @bottom_bar_header = "Collections"
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
  end

  # GET /collections/1/edit
  def edit
  end

  # POST /collections
  # POST /collections.json
  def create
    @collection = current_user.collections.new(collection_params)
      if @collection.save
        # SharedCollection.create({user_id: current_user.id, collection_id: @collection.id})            # Add current user to shared collections
        redirect_to @collection
      else
        render :new 
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection
      @collection = current_user.collections.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collection_params
      params.require(:collection).permit(:title, :user_id, :parent_id)
    end
end
