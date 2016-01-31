class Researcher < ActiveRecord::Base
	belongs_to :search_group
	before_save :set_search_group_id

  # Set the search group id for the current researcher
  def set_search_group_id
    self.search_group_id = 1
  end
end
