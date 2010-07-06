# == Schema Information
# Schema version: 20100705214924
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  password   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  has_many :incomes
  has_many :bills

  attr_accessible :name, :email, :password

  validates_presence_of :name, :email
  validates_length_of :name, :maximum => 50
  validates_format_of :email, :with => Constant::EmailRegex
  validates_uniqueness_of :email, :case_sensitive => false
end

