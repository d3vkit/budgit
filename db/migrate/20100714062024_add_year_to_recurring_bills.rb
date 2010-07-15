class AddYearToRecurringBills < ActiveRecord::Migration
  def self.up
    add_column :recurring_bills, :year, :int
  end

  def self.down
    remove_column :recurring_bills, :year
  end
end
