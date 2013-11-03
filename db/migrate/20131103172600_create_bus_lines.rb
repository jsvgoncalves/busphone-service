class CreateBusLines < ActiveRecord::Migration
  def change
    create_table :bus_lines do |t|
      t.integer :line_number

      t.timestamps
    end
  end
end
