class AddUniqueToUuid < ActiveRecord::Migration
  def change
    add_index(:tickets, :uuid, :unique => true)
  end
end
