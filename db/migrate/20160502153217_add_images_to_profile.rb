class AddImagesToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :poster_img_id, :integer
    add_column :profiles, :profile_img_id, :integer
  end
end
