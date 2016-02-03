class CreateResearcherRankings < ActiveRecord::Migration
  def change
    create_table :researcher_rankings do |t|
      t.integer :search_id
      t.integer :researcher_id
      t.boolean :result_1
      t.boolean :result_2
      t.boolean :result_3
      t.boolean :result_4
      t.boolean :result_5
      t.boolean :result_6
      t.boolean :result_7
      t.boolean :result_8
      t.boolean :result_9
      t.boolean :result_10

      t.timestamps
    end
  end
end
