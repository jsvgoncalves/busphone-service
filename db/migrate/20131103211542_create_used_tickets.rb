class CreateUsedTickets < ActiveRecord::Migration
  def change
    create_table :used_tickets do |t|
      t.timestamp :date_used
      t.integer :ticket_type
      t.integer :user_id

      t.timestamps
    end
  end
end
