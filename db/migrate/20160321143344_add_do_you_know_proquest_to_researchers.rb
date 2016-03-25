class AddDoYouKnowProquestToResearchers < ActiveRecord::Migration
  def change
    add_column :researchers, :do_you_know_proquest, :boolean
  end
end
