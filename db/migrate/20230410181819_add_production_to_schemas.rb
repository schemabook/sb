class AddProductionToSchemas < ActiveRecord::Migration[7.0]
  def change
    add_column :schemas, :production, :boolean, default: false
  end
end
