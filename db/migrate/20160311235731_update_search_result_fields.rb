class UpdateSearchResultFields < ActiveRecord::Migration
  def change
    remove_column :search_results, :result_title
    remove_column :search_results, :result_journal
    remove_column :search_results, :result_publication_year
    remove_column :search_results, :result_start_page
    remove_column :search_results, :result_end_page
    remove_column :search_results, :result_authors

    add_column :search_results, :platform_id, :integer
    add_column :search_results, :search_result_title, :text
    add_column :search_results, :search_result_metadata, :text
  end
end
