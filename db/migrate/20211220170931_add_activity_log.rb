class AddActivityLog < ActiveRecord::Migration[6.1]
  def change
    create_table :activity_logs
    add_reference :activity_logs, :business
  end
end
