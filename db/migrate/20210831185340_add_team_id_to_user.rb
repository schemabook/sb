class AddTeamIdToUser < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :team, index: true
  end
end
