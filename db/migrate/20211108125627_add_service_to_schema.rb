class AddServiceToSchema < ActiveRecord::Migration[6.1]
  def change
    add_reference :schemas, :service
  end
end
