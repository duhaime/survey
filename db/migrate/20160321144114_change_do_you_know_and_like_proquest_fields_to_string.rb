class ChangeDoYouKnowAndLikeProquestFieldsToString < ActiveRecord::Migration
  def change
    remove_column :researchers, :do_you_know_proquest
    remove_column :researchers, :do_you_like_proquest
    add_column :researchers, :do_you_know_proquest, :string
    add_column :researchers, :do_you_like_proquest, :string
  end
end
