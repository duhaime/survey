class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.integer :search_id
      t.string :search_phrase

      t.timestamps
    end
  end
end
