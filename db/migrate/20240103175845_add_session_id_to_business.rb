class AddSessionIdToBusiness < ActiveRecord::Migration[7.0]
  def change
    add_column :businesses, :session_id, :string
  end
end
