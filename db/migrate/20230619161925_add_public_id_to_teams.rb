class AddPublicIdToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :public_id, :string
    add_index :teams, :public_id
  end
end
