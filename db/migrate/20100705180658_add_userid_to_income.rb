class AddUseridToIncome < ActiveRecord::Migration
  def self.up
    add_column :incomes, :user_id, :integer
  end

  def self.down
    remove_Column :incomes, :user_id
  end
end

