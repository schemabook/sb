class IntroducesUserOnlyActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :user_only, :boolean, default: false
    add_index :activities, :user_only
  end
end
