class PayPeriod < ActiveRecord::Base
  attr_accessible :begins, :ends
  belongs_to :user
end

