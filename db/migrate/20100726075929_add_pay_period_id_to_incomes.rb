class AddPayPeriodIdToIncomes < ActiveRecord::Migration
  def self.up
    add_column :incomes, :pay_period_id, :integer
  end

  def self.down
    remove_column :incomes, :pay_period_id
  end
end
