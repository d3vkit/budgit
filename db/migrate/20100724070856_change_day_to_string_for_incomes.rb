class ChangeDayToStringForIncomes < ActiveRecord::Migration
  def self.up
    change_column :incomes, :day, :string
  end

  def self.down
    change_column :incomes, :day, :integer
  end
end

