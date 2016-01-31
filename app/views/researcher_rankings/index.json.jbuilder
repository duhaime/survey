json.array!(@researcher_rankings) do |researcher_ranking|
  json.extract! researcher_ranking, :id, :search_id, :researcher_id, :result_one, :result_two, :result_three, :result_four, :result_five, :result_six, :result_seven, :result_eight, :result_nine, :result_ten
  json.url researcher_ranking_url(researcher_ranking, format: :json)
end
