class AddUseridToBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :user_id, :integer
  end

  def self.down
    remove_column :bills, :user_id
  end
end

