class AddSearchPhraseToSearchGroup < ActiveRecord::Migration
  def change
    add_column :search_groups, :search_phrase, :text
  end
end
