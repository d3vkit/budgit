class AddHoursWorkedToRecurringIncomes < ActiveRecord::Migration
  def self.up
    add_column :recurring_incomes, :hours_worked, :integer
  end

  def self.down
    remove_column :recurring_incomes, :hours_worked
  end
end
