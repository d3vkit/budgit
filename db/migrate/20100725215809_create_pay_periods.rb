class CreatePayPeriods < ActiveRecord::Migration
  def self.up
    create_table :pay_periods do |t|
      t.date :begins
      t.date :ends

      t.timestamps
    end
  end

  def self.down
    drop_table :pay_periods
  end
end

