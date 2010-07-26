class RecurringIncome < ActiveRecord::Base
  attr_accessible :frequency, :amount, :name, :day, :weekday, :month, :year, :alternator, :per, :hours_worked

  belongs_to :user
  has_many :incomes, :dependent => :destroy

  validates_presence_of :name, :frequency, :amount, :per, :hours_worked
  validates_length_of :name, :maximum => 50
  validates_numericality_of :amount, :hours_worked

  serialize :day

end

