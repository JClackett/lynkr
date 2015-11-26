class HomeController < ApplicationController 

	def index 

		@collections = current_user.collections
		@bottom_bar_header = "Collections"

	end

end