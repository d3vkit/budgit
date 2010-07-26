class RemoveTypeFromIncomes < ActiveRecord::Migration
  def self.up
    remove_column :incomes, :type
  end

  def self.down
    add_column :incomes, :type, :string
  end
end
