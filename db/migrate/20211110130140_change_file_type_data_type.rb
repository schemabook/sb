class ChangeFileTypeDataType < ActiveRecord::Migration[6.1]
  def change
    change_column :formats, :file_type, :integer, using: 'file_type::integer'
  end
end
