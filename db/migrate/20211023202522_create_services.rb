class CreateServices < ActiveRecord::Migration[6.1]
  def change
    create_table :services do |t|
      t.string :name
      t.text :description
      t.references :team

      t.timestamps
    end

    add_index :services, [:name, :team_id], unique: true
  end
end
