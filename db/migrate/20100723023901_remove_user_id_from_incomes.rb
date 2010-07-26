class RemoveUserIdFromIncomes < ActiveRecord::Migration
  def self.up
    remove_column :incomes, :user_id
  end

  def self.down
    add_column :incomes, :user_id, :integer
  end
end
