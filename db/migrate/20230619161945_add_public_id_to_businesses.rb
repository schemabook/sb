class AddPublicIdToBusinesses < ActiveRecord::Migration[7.0]
  def change
    add_column :businesses, :public_id, :string
    add_index :businesses, :public_id
  end
end
