class AddResponseCodeToWebhooks < ActiveRecord::Migration[7.1]
  def change
    add_column :webhooks, :response_code, :integer
    add_column :webhooks, :response_body, :text
  end
end
