class AddFormatIdToSchema < ActiveRecord::Migration[6.1]
  def change
    add_reference :schemas, :format
  end
end
