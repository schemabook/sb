class AddIndexToWebhooks < ActiveRecord::Migration[7.1]
  def change
    add_column :webhooks, :index, :integer
  end
end
