class AddScopeIndexToTeam < ActiveRecord::Migration[6.1]
  def change
    add_index :teams, [:name, :business_id], unique: true
  end
end
