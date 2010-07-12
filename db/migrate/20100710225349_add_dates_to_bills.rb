class AddDatesToBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :dates, :string
  end

  def self.down
    remove_column :bills, :dates, :string
  end
end

