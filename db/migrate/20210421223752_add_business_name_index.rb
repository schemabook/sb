class AddBusinessNameIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :businesses, :name, unique: true
  end
end
