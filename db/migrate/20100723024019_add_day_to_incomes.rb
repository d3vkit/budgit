class AddDayToIncomes < ActiveRecord::Migration
  def self.up
    add_column :incomes, :day, :integer
  end

  def self.down
    remove_column :incomes, :day
  end
end
