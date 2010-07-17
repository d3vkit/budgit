class AlterBills < ActiveRecord::Migration
  def self.up
    change_column :bills, :day, :int
    change_column :bills, :month, :int
    change_column :bills, :weekday, :int
  end

  def self.down
    change_column :bills, :day, :string
    change_column :bills, :month, :string
    change_column :bills, :weekday, :string
  end
end

