class AddAttributesToBusiness < ActiveRecord::Migration[6.1]
  def change
    add_column :businesses, :street_address, :string
    add_column :businesses, :city, :string
    add_column :businesses, :state, :string
    add_column :businesses, :postal, :string
    add_column :businesses, :country, :string
  end
end
