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

before_save :set_default_title

# ------------------------------------------------------------------------------
# Nested Attributes
# ------------------------------------------------------------------------------



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

def set_default_title
	puts self.title
	if self.title.empty?
		self.title = "Collection"
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
