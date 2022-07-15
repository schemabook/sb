class IntroduceStakeholders < ActiveRecord::Migration[6.1]
  def change
    create_table :stakeholders do |t|
      t.references :user, index: true
      t.references :schema, index: true
      t.timestamps
    end
  end
end
