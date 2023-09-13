class AddPublicIdToServices < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :public_id, :string
    add_index :services, :public_id
  end
end
