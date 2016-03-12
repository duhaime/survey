class AddPlatformIdToFields < ActiveRecord::Migration
  def change
    add_column :researcher_rankings, :platform_id, :integer
    add_column :search_groups, :platform_id, :integer
    add_column :searches, :platform_id, :integer
  end
end
