json.array!(@images) do |image|
  json.extract! image, :id, :p_hash, :timestamps
  json.url image_url(image, format: :json)
end
