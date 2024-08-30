class CreateWebhooks < ActiveRecord::Migration[7.1]
  def change
    create_table :webhooks do |t|
      t.bigint :schema_id, null: false
      t.bigint :user_id, null: false
      t.string :url, null: false

      t.timestamps
    end
  end
end
