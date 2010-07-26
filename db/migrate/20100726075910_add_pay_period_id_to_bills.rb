class AddPayPeriodIdToBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :pay_period_id, :integer
  end

  def self.down
    remove_column :bills, :pay_period_id
  end
end
