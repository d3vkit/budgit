class AddYearToIncomes < ActiveRecord::Migration
  def self.up
    add_column :incomes, :year, :integer
  end

  def self.down
    remove_column :incomes, :year
  end
end
