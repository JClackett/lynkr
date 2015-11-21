class Collection < ActiveRecord::Base

  has_many :users_collections
  has_many :users, :through => :users_collections
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id

  has_many :collections_links
  has_many :links. :through => :collections_links

end
