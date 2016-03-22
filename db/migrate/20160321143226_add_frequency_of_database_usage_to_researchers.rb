class AddFrequencyOfDatabaseUsageToResearchers < ActiveRecord::Migration
  def change
    add_column :researchers, :frequency_of_database_usage, :string
  end
end
