class Search < ActiveRecord::Base
	belongs_to :search_group
	has_many :search_results
end
