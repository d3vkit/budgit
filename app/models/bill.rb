class Bill < ActiveRecord::Base
  attr_accessible :frequency, :amount, :name, :day, :weekday, :month, :year, :alternator, :occurs_once

  belongs_to :recurring_bill
  belongs_to :pay_period
  #belongs_to :user
  has_one :user, :through => :recurring_bill

  validates_presence_of :name, :frequency, :amount
  validates_numericality_of :amount

  serialize :day

  def get_months
    #possibly use this to find months?
  end

  def duplicate(opts={})
    #opts = default_opts.merge(opts)

    dup = self.clone
    dup.day = opts[:day] if !opts[:day].blank?
    return dup
  end

end

