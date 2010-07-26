class AddHoursWorkedToIncomes < ActiveRecord::Migration
  def self.up
    add_column :incomes, :hours_worked, :integer
  end

  def self.down
    remove_column :incomes, :hours_worked
  end
end
