class AddSubscribeDateToBusiness < ActiveRecord::Migration[7.0]
  def change
    add_column :businesses, :subscribed_at, :datetime
  end
end
