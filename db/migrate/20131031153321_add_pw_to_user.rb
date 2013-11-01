class AddPwToUser < ActiveRecord::Migration
  def change
    add_column :users, :pw, :string
  end
end
