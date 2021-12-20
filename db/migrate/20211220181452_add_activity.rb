class AddActivity < ActiveRecord::Migration[6.1]
  def change
    create_table :activities do |t|
      # resource
      t.integer :resource_id
      t.string :resource_class

      # the action taken by the user
      t.string :title

      # the details of the action
      t.string :detail

      t.timestamps
    end

    add_reference :activities, :user
    add_reference :activities, :activity_log
  end
end
