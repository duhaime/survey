class StoreResearcherEmailNotResearcherIdInResearcherRanking < ActiveRecord::Migration
  def change
    remove_column :researcher_rankings, :researcher_id
    add_column :researcher_rankings, :email, :text
  end
end
