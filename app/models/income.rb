class Income < ActiveRecord::Base
  attr_accessible :frequency, :amount, :name, :day, :weekday, :month, :year, :alternator, :per, :hours_worked, :occurs_once

  belongs_to :recurring_income
  belongs_to :pay_period
  #belongs_to :user
  has_one :user, :through => :recurring_income

  validates_presence_of :name, :frequency, :amount, :per, :hours_worked
  validates_length_of :name, :maximum => 15
  validates_numericality_of :amount, :hours_worked

  serialize :day
end

