class ChangeDayToStringForRecurringIncomes < ActiveRecord::Migration
  def self.up
    change_column :recurring_incomes, :day, :string
  end

  def self.down
    change_column :recurring_incomes, :day, :integer
  end
end

