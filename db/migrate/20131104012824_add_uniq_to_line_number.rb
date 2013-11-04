class AddUniqToLineNumber < ActiveRecord::Migration
  def change
        add_index(:bus_lines, :line_number, :unique => true)
  end
end
