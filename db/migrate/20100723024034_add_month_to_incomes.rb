class AddMonthToIncomes < ActiveRecord::Migration
  def self.up
    add_column :incomes, :month, :integer
  end

  def self.down
    remove_column :incomes, :month
  end
end
