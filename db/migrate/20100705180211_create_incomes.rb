class CreateIncomes < ActiveRecord::Migration
  def self.up
    create_table :incomes do |t|
      t.string :name
      t.string :occurance
      t.integer :amount
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :incomes
  end
end
