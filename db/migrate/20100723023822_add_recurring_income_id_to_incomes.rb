class AddRecurringIncomeIdToIncomes < ActiveRecord::Migration
  def self.up
    add_column :incomes, :recurring_income_id, :integer
  end

  def self.down
    remove_column :incomes, :recurring_income_id
  end
end
