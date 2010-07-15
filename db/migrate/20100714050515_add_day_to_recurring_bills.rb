class AddDayToRecurringBills < ActiveRecord::Migration
  def self.up
    add_column :recurring_bills, :day, :int
  end

  def self.down
    remove_column :recurring_bills, :day
  end
end
