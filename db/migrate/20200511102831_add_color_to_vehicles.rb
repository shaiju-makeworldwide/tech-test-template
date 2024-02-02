class AddColorToVehicles < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicles, :color, :string, index: true
  end
end
