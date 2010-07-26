class ChangeDayToStringForBills < ActiveRecord::Migration
  def self.up
    change_column :bills, :day, :string
  end

  def self.down
    change_column :bills, :day, :integer
  end
end

