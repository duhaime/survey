json.array!(@researcher_rankings) do |researcher_ranking|
  json.extract! researcher_ranking, :id, :search_id, :researcher_id, :result_1, :result_2, :result_3, :result_4, :result_5, :result_6, :result_7, :result_8, :result_9, :result_10
  json.url researcher_ranking_url(researcher_ranking, format: :json)
end
