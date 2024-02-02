class AddUniqueIndexToVehicles < ActiveRecord::Migration[6.0]
  def change
    remove_index :vehicles, :chassis_number
    add_index :vehicles, :chassis_number, unique: true
  end
end
