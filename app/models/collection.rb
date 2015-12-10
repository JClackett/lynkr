class Collection < ActiveRecord::Base


# ------------------------------------------------------------------------------
# Includes & Extensions
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# Attributes
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# Associations
# ------------------------------------------------------------------------------

belongs_to :user
has_many :shared_collections, :dependent => :destroy
has_many :links , :dependent => :destroy


# ------------------------------------------------------------------------------
# Validations
# ------------------------------------------------------------------------------

  # validates :title, :presence => true


# ------------------------------------------------------------------------------
# Callbacks
# ------------------------------------------------------------------------------

after_save :set_default_title
after_save :assign_shared_collections

# ------------------------------------------------------------------------------
# Nested Attributes
# ------------------------------------------------------------------------------

accepts_nested_attributes_for :shared_collections

# ------------------------------------------------------------------------------
# Scopes
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# Other
# ------------------------------------------------------------------------------

acts_as_tree     # Nested collections



# ------------------------------------------------------------------------------
# Class Methods
# ------------------------------------------------------------------------------

def set_default_title    # Self explanatary 
	if self.title.empty?
		self.title = "Collection ##{self.id}"
		self.save
	end
end

def assign_shared_collections   # On creation, assigns any users in parent collection to also have access
	
	if self.parent
		collection_parent = self.parent 
		shared_collections = SharedCollection.where(collection_id: collection_parent.id)
		shared_user_ids = shared_collections.pluck(:shared_user_id)

		shared_user_ids.each do |current_user_id|
			@shared_collection = SharedCollection.new
			@shared_collection.collection_id = self.id

			if current_user_id == self.user_id    # Non owner of parent creates a collection inside parent, allows the creator to see inside, by creating shared collection record
				@shared_collection.user_id = self.user_id
				@shared_collection.shared_user_id = collection_parent.user_id
				@shared_collection.shared_email = User.where(id: collection_parent.user_id).first.email

			else	# Assigning all shared users of parent to children created by owner of parent
				@shared_collection.user_id = collection_parent.user_id
				@shared_collection.shared_user_id = current_user_id
				@shared_collection.shared_email = User.where(id: current_user_id).first.email
			end

			@shared_collection.save
		end

	else
	end

end

# ------------------------------------------------------------------------------
# Instance Methods
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
protected
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
private
# ------------------------------------------------------------------------------




end
