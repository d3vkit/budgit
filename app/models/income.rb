# == Schema Information
# Schema version: 20100705214924
#
# Table name: incomes
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  occurance  :string(255)
#  amount     :integer
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

class Income < ActiveRecord::Base
  attr_accessible :occurance, :amount, :type, :name

  belongs_to :user
end

