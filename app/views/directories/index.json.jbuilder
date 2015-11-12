json.array!(@directories) do |directory|
  json.extract! directory, :id, :path
  json.url directory_url(directory, format: :json)
end
