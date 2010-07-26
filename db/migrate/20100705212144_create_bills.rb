class CreateBills < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      t.string :name
      t.string :frequency
      t.decimal :amount, :precision =>8, :scale => 2
      t.integer :day
      t.integer :year
      t.integer :month
      t.integer :weekday
      t.string :alternator
      t.integer :recurring_bill_id

      t.timestamps
    end
  end

  def self.down
    drop_table :bills
  end
end

