class RenameEmailFieldInResearcherRanking < ActiveRecord::Migration
  def change
    remove_column :researcher_rankings, :email
    add_column :researcher_rankings, :researcher_email, :text
  end
end
