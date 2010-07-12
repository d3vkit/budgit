class RemoveYearFromBills < ActiveRecord::Migration
  def self.up
    remove_column :bills, :year
  end

  def self.down
    add_column :bills, :year, :string
  end
end
