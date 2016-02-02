class CreateResearcherRankings < ActiveRecord::Migration
  def change
    create_table :researcher_rankings do |t|
      t.boolean :search_id
      t.boolean :researcher_id
      t.boolean :result_one
      t.boolean :result_two
      t.boolean :result_three
      t.boolean :result_four
      t.boolean :result_five
      t.boolean :result_six
      t.boolean :result_seven
      t.boolean :result_eight
      t.boolean :result_nine
      t.boolean :result_ten

      t.timestamps
    end
  end
end
