class SearchGroup < ActiveRecord::Base
	has_many :researchers
	has_many :searches
end
