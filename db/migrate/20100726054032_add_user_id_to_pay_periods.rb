class AddUserIdToPayPeriods < ActiveRecord::Migration
  def self.up
    add_column :pay_periods, :user_id, :integer
  end

  def self.down
    remove_column :pay_periods, :user_id
  end
end
