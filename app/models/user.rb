class User < ActiveRecord::Base

# ------------------------------------------------------------------------------
# Includes & Extensions
# ------------------------------------------------------------------------------

# Include default devise modules. Others available are:
# :confirmable, :lockable, :timeoutable and :omniauthable
   devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :trackable, :validatable


# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# Attributes
# ------------------------------------------------------------------------------

  

# ------------------------------------------------------------------------------
# Associations
# ------------------------------------------------------------------------------

has_many :collections

has_many :shared_collections, :dependent => :destroy
has_many :being_shared_collections, :class_name => "SharedCollection", :foreign_key => "shared_user_id", :dependent => :destroy
#this is for getting collections objects which the user has been shared by other users 
has_many :shared_collections_by_others, :through => :being_shared_collections, :source => :collection

has_many :favourites
has_many :links


# ------------------------------------------------------------------------------
# Validations
# ------------------------------------------------------------------------------

    validates :email, :presence => true, :uniqueness => true


# ------------------------------------------------------------------------------
# Callbacks
# ------------------------------------------------------------------------------

after_create :check_and_assign_shared_ids_to_shared_collections


# ------------------------------------------------------------------------------
# Nested Attributes
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# Scopes
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# Other
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# Class Methods
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# Instance Methods
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
protected
# ------------------------------------------------------------------------------
#this is to make sure the new user ,of which the email addresses already used to share collections by others, to have access to those collections 
def check_and_assign_shared_ids_to_shared_collections     
    #First checking if the new user's email exists in any of Sharecollection records 
    shared_collections_with_same_email = SharedCollection.find_all_by_shared_email(self.email) 
  
    if shared_collections_with_same_email       
      #loop and update the shared user id with this new user id  
      shared_collections_with_same_email.each do |shared_collection| 
        shared_collection.shared_user_id = self.id 
        shared_collection.save 
      end
    end    
end


# ------------------------------------------------------------------------------
private
# ------------------------------------------------------------------------------




end
