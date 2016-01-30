json.array!(@searches) do |search|
  json.extract! search, :id, :search_id, :search_phrase
  json.url search_url(search, format: :json)
end
