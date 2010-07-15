class CreateTableRecurringBills < ActiveRecord::Migration
  def self.up
    create_table :recurring_bills do |t|
      t.string :name
      t.string :frequency
      t.string :amount
      t.string :month
      t.string :weekday
      t.string :alternator
      t.references :user

      t.timestamps

    end
  end

  def self.down
    drop_table :recurring_bills
  end
end

