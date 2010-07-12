# == Schema Information
# Schema version: 20100705214924
#
# Table name: bills
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  occurance  :string(255)
#  amount     :integer
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

class Bill < ActiveRecord::Base
  attr_accessible :frequency, :amount, :name, :day, :weekday, :month, :alternator

  belongs_to :user

  validates_presence_of :name, :frequency, :amount
  validates_length_of :name, :maximum => 50
  validates_numericality_of :amount
end

