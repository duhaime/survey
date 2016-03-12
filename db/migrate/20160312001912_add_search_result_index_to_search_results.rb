class AddSearchResultIndexToSearchResults < ActiveRecord::Migration
  def change
    add_column :search_results, :search_result_index, :integer
  end
end
