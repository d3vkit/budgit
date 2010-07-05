class Bill < ActiveRecord::Base
  attr_accessible :occurance, :amount, :name

  belongs_to :user
end

