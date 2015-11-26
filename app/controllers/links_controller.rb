class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy, :favourite]
  before_action :authenticate_user!
  before_action :sidebar_collections, only: [:index, :show, :new, :edit, :favourites]



  # GET /links
  # GET /links.json
  # Show all links the user created
  def index
    @links = current_user.links  
    @bottom_bar_header = "All Links"
  end

  # GET /links/1
  # GET /links/1.json
  def show
  end

  # GET /links/new
  def new
    @bottom_bar_header = "New Link"
    @link = current_user.links.new
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  # POST /links.json
  def create
    @link = current_user.links.new(link_params)

    respond_to do |format|
      if @link.save
        format.html { redirect_to links_path, notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
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
      respond_to do |format|
          format.js
      end
    else
      @favourite = @link.favourites.new(user: current_user)
      @favourite.save
      respond_to do |format|
        format.js
      end
    end 
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = current_user.links.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:url, :description, :image_url, :user_id, collection_ids: [] )
    end
end
