class AddMonthToBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :month, :string
  end

  def self.down
    remove_column :bills, :month
  end
end
