class AddChannelToTeam < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :channel, :string, null: true
  end
end
