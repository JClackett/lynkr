class CreateCollectionsLinks < ActiveRecord::Migration
  def change
    create_table :collections_links do |t|
      t.integer :collection_id
      t.integer :link_id

      t.timestamps null: false
    end
  end
end
