class AddOccursOnceToBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :occurs_once, :boolean, :default => false
  end

  def self.down
    remove_column :bills, :occurs_once
  end
end

