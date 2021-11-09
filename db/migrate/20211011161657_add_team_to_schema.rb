class AddTeamToSchema < ActiveRecord::Migration[6.1]
  def change
    add_reference :schemas, :team, index: true
  end
end
