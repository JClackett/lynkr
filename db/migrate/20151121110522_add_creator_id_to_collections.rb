class AddCreatorIdToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :creator_id, :integer
  end
end
