class AddWeekdayToBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :weekday, :string
  end

  def self.down
    remove_column :bills, :weekday
  end
end
