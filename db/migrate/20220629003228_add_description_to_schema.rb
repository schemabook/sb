class AddDescriptionToSchema < ActiveRecord::Migration[6.1]
  def change
    add_column :schemas, :description, :text
  end
end
