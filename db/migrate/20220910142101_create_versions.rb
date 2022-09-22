class CreateVersions < ActiveRecord::Migration[7.0]
  def change
    create_table :versions do |t|
      t.integer :schema_id # versions belong to schemas

      t.timestamps
    end
  end
end
