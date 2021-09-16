class AddBusinessIdToTeam < ActiveRecord::Migration[6.1]
  def change
    add_reference :teams, :business
  end
end
