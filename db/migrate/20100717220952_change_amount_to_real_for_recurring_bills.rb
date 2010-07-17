class ChangeAmountToRealForRecurringBills < ActiveRecord::Migration
  def self.up
    change_column :recurring_bills, :amount, :real
  end

  def self.down
    change_column :recurring_bills, :amount, :int
  end
end

