class AddAlternatorToBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :alternator, :string
  end

  def self.down
    remove_column :bills, :alternator
  end
end
