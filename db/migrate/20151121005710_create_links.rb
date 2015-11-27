class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :url
      t.string :description
      t.string :image_url
      t.integer :user_id
      t.integer :collection_id

      t.timestamps null: false
    end
  end
end
