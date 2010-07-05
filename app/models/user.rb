class User < ActiveRecord::Base
  has_many :incomes
  has_many :bills
end

