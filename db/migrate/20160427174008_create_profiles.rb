class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.date :birthday
      t.string :country
      t.integer :user_id
      t.string :education
      t.string :profession
      t.text :about_you

      t.timestamps null: false
    end
  end
end
