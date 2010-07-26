class AddAlternatorToIncomes < ActiveRecord::Migration
  def self.up
    add_column :incomes, :alternator, :string
  end

  def self.down
    remove_column :incomes, :alternator
  end
end
