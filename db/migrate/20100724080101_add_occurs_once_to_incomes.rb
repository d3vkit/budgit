class AddOccursOnceToIncomes < ActiveRecord::Migration
  def self.up
    add_column :incomes, :occurs_once, :boolean, :default => false
  end

  def self.down
    remove_column :incomes, :occurs_once
  end
end

