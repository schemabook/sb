class AddAdminColumnToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :administrators, :boolean, default: false
    add_index :teams, :administrators
  end
end
