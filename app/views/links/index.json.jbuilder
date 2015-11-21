json.array!(@links) do |link|
  json.extract! link, :id, :url, :description, :image_url, :user_id
  json.url link_url(link, format: :json)
end
