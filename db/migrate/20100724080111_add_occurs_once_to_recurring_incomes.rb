class AddOccursOnceToRecurringIncomes < ActiveRecord::Migration
  def self.up
    add_column :recurring_incomes, :occurs_once, :boolean, :default => false
  end

  def self.down
    remove_column :recurring_incomes, :occurs_once
  end
end

