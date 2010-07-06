class Constant < ActiveRecord::Base
  SITE_NAME = "Budgit"
  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
end

