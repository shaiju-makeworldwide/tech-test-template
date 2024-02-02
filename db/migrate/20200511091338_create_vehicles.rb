class CreateVehicles < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicles do |t|
      t.belongs_to :customer
      t.string :name, index: true
      t.integer :year
      t.string :chassis_number, index: true
      t.datetime :registered_at
      t.integer :odometer, default: 0
      t.timestamps
    end
  end
end
