class CreateBuses < ActiveRecord::Migration
  def change
    create_table :buses do |t|
      t.integer :bus_plate

      t.timestamps
    end
  end
end
