class RecurringBill < ActiveRecord::Base
  attr_accessible :frequency, :amount, :name, :day, :weekday, :month, :year, :alternator

  belongs_to :user
  has_many :bills, :dependent => :destroy

  validates_presence_of :name, :frequency, :amount
  validates_numericality_of :amount

  serialize :day

end

