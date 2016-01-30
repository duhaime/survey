class CreateSearchGroups < ActiveRecord::Migration
  def change
    create_table :search_groups do |t|
      t.integer :search_group_id
      t.integer :search_id

      t.timestamps
    end
  end
end
