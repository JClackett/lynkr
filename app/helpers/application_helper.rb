module ApplicationHelper

	  # Returns the full title on a per-page basis.
	 def full_title(page_title)
		base_title = "Lynkr"
		if page_title.empty?
			base_title
		else
			"#{page_title} | #{base_title}"
		end
	 end

	def avatar_url(user)
		gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
		return "http://gravatar.com/avatar/#{gravatar_id}.png"
	end
	
end
