class SharedCollection < ActiveRecord::Migration
  def change
	 create_table :shared_collections do |t|
		t.integer :user_id
		t.string :shared_email
		t.integer :shared_user_id
		t.integer :collection_id
		t.string :message

		t.timestamps null: false
	end
  end
end
