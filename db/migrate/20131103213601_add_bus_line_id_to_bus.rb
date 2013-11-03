class AddBusLineIdToBus < ActiveRecord::Migration
  def change
    add_column :buses, :bus_line_id, :integer
  end
end
