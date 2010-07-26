class ChangeDayToStringForRecurringBills < ActiveRecord::Migration
  def self.up
    change_column :recurring_bills, :day, :string
  end

  def self.down
    change_column :recurring_bills, :day, :integer
  end
end

