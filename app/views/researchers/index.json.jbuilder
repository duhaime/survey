json.array!(@researchers) do |researcher|
  json.extract! researcher, :id, :email, :name, :university, :position, :search_group_id
  json.url researcher_url(researcher, format: :json)
end
