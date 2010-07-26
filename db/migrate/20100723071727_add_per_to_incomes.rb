class AddPerToIncomes < ActiveRecord::Migration
  def self.up
    add_column :incomes, :per, :string
  end

  def self.down
    remove_column :incomes, :per
  end
end
