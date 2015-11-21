class Link < ActiveRecord::Base
	belongs_to :user

	has_many :collections_links
	has_many :collections, :through => :collections_links
end
