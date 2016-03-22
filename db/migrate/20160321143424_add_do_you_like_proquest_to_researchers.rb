class AddDoYouLikeProquestToResearchers < ActiveRecord::Migration
  def change
    add_column :researchers, :do_you_like_proquest, :boolean
  end
end
