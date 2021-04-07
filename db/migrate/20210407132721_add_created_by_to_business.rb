class AddCreatedByToBusiness < ActiveRecord::Migration[6.1]
  def change
    add_column :businesses, :created_by, :integer
  end
end
