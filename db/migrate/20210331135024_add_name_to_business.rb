class AddNameToBusiness < ActiveRecord::Migration[6.1]
  def change
    add_column :businesses, :name, :string, null: false, default: 'example'
  end
end
