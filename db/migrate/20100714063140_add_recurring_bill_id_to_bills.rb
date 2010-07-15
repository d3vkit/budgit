class AddRecurringBillIdToBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :recurring_bill_id, :int
  end

  def self.down
    remove_column :bills, :recurring_bill_id
  end
end
