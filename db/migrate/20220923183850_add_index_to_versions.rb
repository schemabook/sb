class AddIndexToVersions < ActiveRecord::Migration[7.0]
  def change
    add_column :versions, :index, :integer #, null: false
  end
end
