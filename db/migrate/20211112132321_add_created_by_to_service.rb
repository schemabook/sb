class AddCreatedByToService < ActiveRecord::Migration[6.1]
  def change
    add_column :services, :created_by, :integer
  end
end
