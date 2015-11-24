module LinksHelper




	def shortened_url(url)
		url.truncate(50)
	end

	def short_url(url)
		url.truncate(30)
	end


end
