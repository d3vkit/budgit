class RemoveUserIdFromBills < ActiveRecord::Migration
  def self.up
    remove_column :bills, :user_id
  end

  def self.down
    add_column :bills, :user_id, :int
  end
end

