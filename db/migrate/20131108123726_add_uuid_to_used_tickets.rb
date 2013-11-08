class AddUuidToUsedTickets < ActiveRecord::Migration
  def change
    add_column :used_tickets, :uuid, :string
  end
end
