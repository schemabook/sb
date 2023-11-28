class AddDisabledToBusiness < ActiveRecord::Migration[7.0]
  def change
    add_column :businesses, :disabled, :boolean, default: false
    add_index :businesses, :disabled
  end
end
