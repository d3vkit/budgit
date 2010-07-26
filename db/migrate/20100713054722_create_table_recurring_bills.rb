class CreateTableRecurringBills < ActiveRecord::Migration
  def self.up
    create_table :recurring_bills do |t|
      t.string :name
      t.string :frequency
      t.decimal :amount, :precision =>8, :scale => 2
      t.integer :year
      t.integer :month
      t.integer :day
      t.integer :weekday
      t.string :alternator
      t.references :user

      t.timestamps

    end
  end

  def self.down
    drop_table :recurring_bills
  end
end

