class CreateFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :favorites do |t|
      t.integer :user_id, null: false
      t.integer :schema_id, null: false

      t.timestamps
    end
  end
end
