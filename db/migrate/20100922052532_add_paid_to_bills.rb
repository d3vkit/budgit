class AddPaidToBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :paid, :boolean, :default => false
  end

  def self.down
    remove_column :bills, :paid
  end
end

