class AddUniqueToBusPlate < ActiveRecord::Migration
  def change
    add_index(:buses, :bus_plate, :unique => true)
  end
end
