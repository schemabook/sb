class AddPublicIdToSchemas < ActiveRecord::Migration[7.0]
  def change
    add_column :schemas, :public_id, :string
    add_index :schemas, :public_id
  end
end
