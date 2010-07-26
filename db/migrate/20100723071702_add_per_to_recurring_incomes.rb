class AddPerToRecurringIncomes < ActiveRecord::Migration
  def self.up
    add_column :recurring_incomes, :per, :string
  end

  def self.down
    remove_column :recurring_incomes, :per
  end
end
