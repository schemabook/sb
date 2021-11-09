class AddIndexToSchemas < ActiveRecord::Migration[6.1]
  def change
    add_index :schemas, [:name, :service_id], unique: true
  end
end
