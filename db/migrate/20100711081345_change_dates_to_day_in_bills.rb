class ChangeDatesToDayInBills < ActiveRecord::Migration
  def self.up
    rename_column :bills, :dates, :day
  end

  def self.down
    rename_column :bills, :day, :dates
  end
end

