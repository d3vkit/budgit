class Income < ActiveRecord::Base
  attr_accessible :occurance, :amount, :type, :name

  belongs_to :user
end

