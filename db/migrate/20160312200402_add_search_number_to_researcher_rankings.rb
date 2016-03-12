class AddSearchNumberToResearcherRankings < ActiveRecord::Migration
  def change
    add_column :researcher_rankings, :search_number, :integer
  end
end
