class AddWeekdayToIncomes < ActiveRecord::Migration
  def self.up
    add_column :incomes, :weekday, :integer
  end

  def self.down
    remove_column :incomes, :weekday
  end
end
