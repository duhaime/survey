class CreateResearchers < ActiveRecord::Migration
  def change
    create_table :researchers do |t|
      t.string :email
      t.string :name
      t.string :university
      t.string :position
      t.integer :search_group_id

      t.timestamps
    end
  end
end
