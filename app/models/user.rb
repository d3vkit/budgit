require 'digest'
class User < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10

  has_many :incomes, :through => :recurring_incomes, :dependent => :destroy
  has_many :recurring_incomes, :dependent => :destroy
  has_many :bills, :through => :recurring_bills, :dependent => :destroy
  has_many :recurring_bills, :dependent => :destroy
  has_many :pay_periods, :dependent => :destroy
  has_many :funds, :dependent => :destroy

  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  validates_presence_of :name, :email
  validates_length_of :name, :maximum => 50
  validates_format_of :email, :with => Constant::EmailRegex
  validates_uniqueness_of :email, :case_sensitive => false
  validates_confirmation_of :password
  validates_presence_of :password
  validates_length_of :password, :within => 6..40

  before_save :encrypt_password

  def has_password?(submitted_password)
    logger.info "Submitted Pass: #{submitted_password}; user pass: #{self.encrypted_password}"
    encrypted_password == encrypt(submitted_password)
  end

  def remember_me!
    self.remember_token = encrypt("#{salt}--#{id}--#{Time.now.utc}")
    save_without_validation
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  private

    def encrypt_password
      unless password.nil?
        self.salt = make_salt
        self.encrypted_password = encrypt(password)
      end
    end

    def encrypt(string)
      secure_hash("#{salt}#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end

