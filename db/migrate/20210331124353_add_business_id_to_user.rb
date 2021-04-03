class AddBusinessIdToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :business_id, :integer
  end
end
