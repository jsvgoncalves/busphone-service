class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :ticket_type
      t.string :uuid
      t.integer :user_id

      t.timestamps
    end
  end
end
