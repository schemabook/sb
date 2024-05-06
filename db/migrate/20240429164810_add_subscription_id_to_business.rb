class AddSubscriptionIdToBusiness < ActiveRecord::Migration[7.0]
  def change
    add_column :businesses, :subscription_id, :string
  end
end
