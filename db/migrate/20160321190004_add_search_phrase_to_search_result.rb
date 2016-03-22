class AddSearchPhraseToSearchResult < ActiveRecord::Migration
  def change
    add_column :search_results, :search_phrase, :string
  end 
end
