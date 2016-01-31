class CreateResearcherRankings < ActiveRecord::Migration
  def change
    create_table :researcher_rankings do |t|
      t.integer :search_id
      t.integer :researcher_id
      t.integer :result_one
      t.integer :result_two
      t.integer :result_three
      t.integer :result_four
      t.integer :result_five
      t.integer :result_six
      t.integer :result_seven
      t.integer :result_eight
      t.integer :result_nine
      t.integer :result_ten

      t.timestamps
    end
  end
end
