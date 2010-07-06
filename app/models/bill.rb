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
  attr_accessible :occurance, :amount, :name

  belongs_to :user
end

