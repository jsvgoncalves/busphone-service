class AddIdToUsedTicket < ActiveRecord::Migration
  def change
    add_column :used_tickets, :bus_id, :integer
  end
end
