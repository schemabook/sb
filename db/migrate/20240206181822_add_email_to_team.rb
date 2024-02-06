class AddEmailToTeam < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :email, :string, null: true
  end
end
