class ChangeAmountAndMonthAndWeekdayToIntForRecurringBills < ActiveRecord::Migration
  def self.up
    change_table :recurring_bills do |t|
      t.change :amount, :int
      t.change :month, :int
      t.change :weekday, :int
    end
  end

  def self.down
    change_table :recurring_bills do |t|
      t.change :amount, :string
      t.change :month, :string
      t.change :weekday, :string
    end
  end
end

