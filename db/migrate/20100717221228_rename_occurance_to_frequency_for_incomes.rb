class RenameOccuranceToFrequencyForIncomes < ActiveRecord::Migration
  def self.up
    rename_column :incomes, :occurance, :frequency
  end

  def self.down
    rename_column :incomes, :frequency, :occurance
  end
end

