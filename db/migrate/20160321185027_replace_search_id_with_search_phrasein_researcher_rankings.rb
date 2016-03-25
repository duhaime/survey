class ReplaceSearchIdWithSearchPhraseinResearcherRankings < ActiveRecord::Migration
  def change
    remove_column :researcher_rankings, :search_id
    add_column :researcher_rankings, :search_phrase, :string
  end
end
