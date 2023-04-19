class AddPaidToBusiness < ActiveRecord::Migration[7.0]
  def change
    add_column :businesses, :paid, :boolean, default: false, null: false
  end
end
