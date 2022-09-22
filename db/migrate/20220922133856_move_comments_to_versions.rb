class MoveCommentsToVersions < ActiveRecord::Migration[7.0]
  def change
    remove_column :comments, :schema_id
    add_column :comments, :version_id, :integer
  end
end
