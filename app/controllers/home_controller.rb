class HomeController < ApplicationController 
  before_action :sidebar_collections
	

	def index 

		@collections = current_user.collections
		@bottom_bar_header = "Collections"

	end

end