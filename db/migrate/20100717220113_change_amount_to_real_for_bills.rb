class ChangeAmountToRealForBills < ActiveRecord::Migration
  def self.up
    change_column :bills, :amount, :real
  end

  def self.down
    change_column :bills, :amount, :int
  end
end

