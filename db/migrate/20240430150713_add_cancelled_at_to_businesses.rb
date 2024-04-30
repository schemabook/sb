class AddCancelledAtToBusinesses < ActiveRecord::Migration[7.0]
  def change
    add_column :businesses, :cancelled_at, :datetime
  end
end
