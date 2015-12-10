class CollectionsController < ApplicationController

	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	# CALLBACKS 
	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	 
	before_action :set_collection, only: [:show, :edit, :update, :destroy, :unfollow]
	before_action :authenticate_user!
	before_action :sidebar_collections, only: [:index, :show, :new, :edit, :browse]


	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	# GET : index
	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	 
	def index 

		@bottom_bar_header = "Dock"

		#show collections shared by others but only the top level
		@all_shared_collections = current_user.shared_collections_by_others
		@being_shared_collections =[]

		if @all_shared_collections.nil?
			@all_shared_collections.each do |shared_collection|
				if current_user.has_share_access?(shared_collection.parent) 
					# Means it cant be the top level collection
				else
					@being_shared_collections.push(shared_collection)
				end
			end
		end

		#show only root collections 
		@collections = current_user.collections.roots.reverse

		#show only root files 
		@links = current_user.links.where("collection_id is NULL").reverse  

	end


	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	# GET : show
	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	 
	def show
	end

	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	# GET : new
	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	 
	def new
		@bottom_bar_header = "New Collection"

		@collection = current_user.collections.new     

		#if there is "collection_id" param, we know that we are under a collection, thus, we will essentially create a subcollection 
		if params[:collection_id] #if we want to create a collection inside another collection 

			#we still need to set the @current_collection to make the buttons working fine 
			@current_collection = Collection.find(params[:collection_id]) 

			#then we make sure the collection we are creating has a parent collection which is the @current_collection 
			@collection.parent_id = @current_collection.id 
		end
	end

	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	# GET : edit
	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------

	def edit
	end

	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	# POST : create
	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	 
	def create 
		@collection = current_user.collections.new(collection_params) 
		if @collection.save 
			flash[:success] = "collection created!"
			redirect_to browse_path(@collection)  #then we redirect to the parent collection 
		else
			render :action => 'new'
		end
	end


	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	# PUT : update
	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	 
	def update
		respond_to do |format|
			if @collection.update(collection_params)
				format.html { redirect_to @collection}
				format.json { render :show, status: :ok, location: @collection }
			else
				format.html { render :edit }
				format.json { render json: @collection.errors, status: :unprocessable_entity }
			end
		end
	end

	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	# DELETE : destroy
	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	 
	def destroy 
		@parent_collection = @collection.parent #grabbing the parent collection 
		#this will destroy the collection along with all the contents inside 
		#sub collections will also be deleted too as well as all files inside 
		@collection.destroy 
		#redirect to a relevant path depending on the parent collection 
		if @parent_collection
			flash[:success] = "collection removed!"
			redirect_to browse_path(@parent_collection) 
		else
			redirect_to root_url       
		end
	end

	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	# GET : browse
	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	 

	def browse 

		#first find the current collections within own collections 
		@current_collection = current_user.collections.find_by_id(params[:collection_id])   
		@is_this_collection_being_shared = false if @current_collection #just an instance variable to help hiding buttons on View 


		#if not found in own collections, find it in being_shared_collections 
		if @current_collection.nil? 
			collection = Collection.find_by_id(params[:collection_id]) 

			@current_collection ||= collection if current_user.has_share_access?(collection)
			@is_this_collection_being_shared = true if @current_collection #just an instance variable to help hiding buttons on View 
		end

		#array of shared collection records with current collection id
		all_shared_collections_current = SharedCollection.where(collection_id: @current_collection.id) 
		#remove any records where user isn't signed up
		@shared_collections_current_filtered = all_shared_collections_current.where.not(shared_user_id: nil) 

		if @current_collection
			@being_shared_collections = []
			@bottom_bar_header = @current_collection.title

			#show collections under this current collection, but not load ones current user has been removed from
			@collections = []
			@current_collection.children.each do |collection|
				if current_user.has_share_access?(collection)
					@collections.push(collection)
				else
				end
			end

			#show only files under this current collection 
			@links = @current_collection.links.reverse
			render :index
		else
			redirect_to root_url 
		end

	end

	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	# POST : share
	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	 
	def share
		#first, we need to separate the emails with the comma 
		email_addresses = params[:email_addresses].split(",") 

		email_addresses.each do |email_address| 

			shared_user = User.find_by_email(email_address) 

			#save the details in the Sharecollection table 
			@shared_collection = current_user.shared_collections.new
			@shared_collection.collection_id = params[:collection_id] 
			@shared_collection.shared_email = email_address 
			@shared_collection.shared_user_id = shared_user.id if shared_user 
			@shared_collection.message = params[:message] 

			current_collection = Collection.where(id: params[:collection_id]).first
			current_collection.descendants.each do |descendant|
				@shared_collection_descendant = current_user.shared_collections.new
				@shared_collection_descendant.collection_id = descendant.id
				@shared_collection_descendant.shared_email = email_address 
				@shared_collection_descendant.shared_user_id = shared_user.id if shared_user 
				@shared_collection_descendant.save
			end

			#getting the shared user id right the owner the email has already signed up with ShareBox 
			#if not, the field "shared_user_id" will be left nil for now. 


			# now we need to send email to the Shared User, except if they already exist, and if they are the owners of the parent
			if SharedCollection.exists?(:shared_user_id => shared_user.id, :collection_id => current_collection.id) || current_collection.user_id == shared_user.id

			else
				@shared_collection.save 
				UserMailer.invitation_to_share(@shared_collection).deliver_now
			end


		end


		#since this action is mainly for ajax (javascript request), we'll respond with js file back (refer to share.js.erb) 
		respond_to do |format| 
			format.js { 
			} 
		end
	end

	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	# DELETE : leave_collection
	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	 
	def unfollow
		@parent_collection = @collection.parent 
		
		## Remove shared collection association to the current collection
		SharedCollection.where(collection_id: @collection.id, shared_user_id: current_user.id).first.destroy

		## Remove any shared collections associations that are descendant of the one unfollowing from
 		@collection.descendants.each do |collection|
 			if SharedCollection.where(collection_id: collection.id, shared_user_id: current_user.id).first
 				SharedCollection.where(collection_id: collection.id, shared_user_id: current_user.id).first.destroy
 			end
 		end

 		## Delete any collections the current user owned under the one he removed himself from.
 		@collection.descendants.each do |descendant|	
 			descendant.destroy if descendant.user_id == current_user.id
 		end

		if @parent_collection && current_user.has_share_access?(@parent_collection)
			redirect_to browse_path(@parent_collection) 
			flash[:success] = "unfollowed collection!"
		else
			redirect_to root_url       
		end	
	end


	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	# PRIVATE
	# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
	 
	private


	# Use callbacks to share common setup or constraints between actions.
	def set_collection
		@collection = Collection.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def collection_params
		params.require(:collection).permit(:title, :user_id, :parent_id, :link_id)
	end
end
