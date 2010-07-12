class ChangeOccuranceToFrequencyInBills < ActiveRecord::Migration
  def self.up
    rename_column :bills, :occurance, :frequency
  end

  def self.down
    rename_column :bills, :frequency, :occurance
  end
end

