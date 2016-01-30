class CreateSearchResults < ActiveRecord::Migration
  def change
    create_table :search_results do |t|
      t.integer :search_id
      t.string :result_title
      t.string :result_journal
      t.string :result_publication_year
      t.string :result_start_page
      t.string :result_end_page
      t.string :result_authors

      t.timestamps
    end
  end
end
