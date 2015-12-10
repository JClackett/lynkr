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

  #to check if a user has acess to this specific collection 
def has_share_access?(collection) 

    #has share access if the collection is one of one of his own 
    return true if self.collections.include?(collection) 

    #has share access if the collection is one of the shared_collections_by_others 
    return true if self.shared_collections_by_others.include?(collection) 

    return_value = false
  

    #for checking sub collections under one of the being_shared_collections   
    if collection.ancestors.nil?
    else
    collection.ancestors.each do |ancestor_collection| 
    
      return_value = self.being_shared_collections.include?(ancestor_collection) 
      if return_value #if it's true 
        return true
      end
    end
  end

  
    return false
end



# ------------------------------------------------------------------------------
# Instance Methods
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
protected
# ------------------------------------------------------------------------------
#this is to make sure the new user ,of which the email addresses already used to share collections by others, to have access to those collections 
def check_and_assign_shared_ids_to_shared_collections     
    #First checking if the new user's email exists in any of Sharecollection records 
    shared_collections_with_same_email = SharedCollection.where(shared_email: self.email)
  
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
