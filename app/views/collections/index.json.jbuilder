json.array!(@collections) do |collection|
  json.extract! collection, :id, :title
  json.url collection_url(collection, format: :json)
end
