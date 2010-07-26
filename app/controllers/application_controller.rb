# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include SessionsHelper
  include BillsHelper

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  def define_dates
    @current_day = Time.now.strftime("%d").to_i
    @current_week = Time.now.strftime("%W").to_i
    @current_month = Time.now.strftime("%m").to_i
    @current_year = Time.now.strftime("%Y").to_i
    @current_date = Date.new(@current_year,@current_month,@current_day)

    @last_month = @current_month - 1
    @next_month = @current_month + 1

    if week_is_even?(@current_week)
      @this_week = "even"
      @next_week = "odd"
    else
      @this_week = "odd"
      @next_week = "even"
    end
  end

  def change_words
    if params[:bill]
      frequency = params[:bill][:frequency].downcase
      weekday = params[:bill][:weekday].downcase
      month = params[:bill][:month].downcase
      day = params[:bill][:day].downcase
      amount = params[:bill][:amount]
    elsif params[:recurring_bill]
      frequency = params[:recurring_bill][:frequency].downcase
      weekday = params[:recurring_bill][:weekday].downcase
      #month = params[:recurring_bill][:month].downcase
      day = params[:recurring_bill][:day].downcase
      amount = params[:recurring_bill][:amount]
    elsif params[:income]
      frequency = params[:income][:frequency].downcase
      weekday = params[:income][:weekday].downcase
      month = params[:income][:month].downcase
      day = params[:income][:day].downcase
      amount = params[:income][:amount]
    elsif params[:recurring_income]
      frequency = params[:recurring_income][:frequency].downcase
      weekday = params[:recurring_income][:weekday].downcase
      #month = params[:recurring_income][:month].downcase
      day = params[:recurring_income][:day].downcase
      amount = params[:recurring_income][:amount]
    end
    @errors = []

    logger.info "Original freq: #{frequency}"

    new_frequency = get_frequency(frequency)
    new_weekday = get_weekday(new_frequency,weekday)
    new_day = get_day(new_frequency,day)
    new_amount = get_amount(amount)

    if !@errors.blank?
      logger.info "errors not blank, returning"
      return
    end
    logger.info "no errors"

    if params[:bill]
      params[:bill][:frequency] = new_frequency.downcase
      params[:bill][:day] = new_day
      params[:bill][:weekday] = new_weekday.to_i if new_weekday.to_i != 0
      #params[:bill][:month] = new_month
      params[:bill][:amount] = new_amount
    elsif params[:recurring_bill]
      params[:recurring_bill][:frequency] = new_frequency.downcase
      params[:recurring_bill][:day] = new_day
      params[:recurring_bill][:weekday] = new_weekday.to_i if new_weekday.to_i != 0
      #params[:recurring_bill][:month] = new_month
      params[:recurring_bill][:amount] = new_amount
    elsif params[:income]
      params[:income][:frequency] = new_frequency.downcase
      params[:income][:day] = new_day
      params[:income][:weekday] = new_weekday.to_i if new_weekday.to_i != 0
      #params[:income][:month] = new_month
      params[:income][:amount] = new_amount
    elsif params[:recurring_income]
      params[:recurring_income][:frequency] = new_frequency.downcase
      params[:recurring_income][:day] = new_day
      params[:recurring_income][:weekday] = new_weekday.to_i if new_weekday.to_i != 0
      #params[:recurring_income][:month] = new_month
      params[:recurring_income][:amount] = new_amount
    end
  end

  def get_frequency(freq)
    #Change frequency into standard format (each month == Monthly)
    #Formats are: weekly, every # weeks
    if freq == "monthly" || freq == "daily" || freq == "hourly" || freq == "weekly" || freq == "yearly"
      new_freq = freq
    elsif freq =~ /every ([\d]+) ([a-z]+)/
      if $1 == '1' || $1 == 'one'
        new_freq = $2.singularize.continuous
      elsif $1 >= '3' || $1 == "three" || $1 == "four" || $1 == "five" || $1 == "six" || $1 == "seven" || $1 == "third" || $1 == "fourth" || $1 == "fifth" || $1 == "sixth" || $1 == "seventh"
        @errors << "Sorry, that frequency is out of range (can not happen more than twice a #{$2.singularize})"
      elsif $2.singularize != 'year'
        new_freq = "every 2 #{$2.singularize.pluralize}"
      else
        @errors << "Sorry, that frequency is out of range (more than 1 year in advance)"
      end
    elsif freq =~ /every ([a-z]+)/ || freq =~ /each ([a-z]+)/
      if $1 == 'week' || $1 == 'day' || $1 == 'month' || $1 == 'year' || $1 == 'hour'
        new_freq = $1.continuous
      end
    elsif freq =~ /bi([a-z]+)/
      new_freq = "every 2 "+$1.uncontinuous.pluralize
    elsif freq =~ /once a ([a-z]+)/
      new_freq = $1.singularize.continuous
    elsif freq =~ /once/ || freq =~ /one time/ || freq =~ /one/
      new_freq = "once"
  elsif freq =~ /twice a month/ || freq =~ /two times a month/ || freq =~ /2 times a month/
      new_freq = "twice a month"
    else
      @errors << "Frequency must be in the form of 'Every Week', 'Each Day', 'Monthly', etc"
    end
    logger.info "new_freq: #{new_freq}"
    return new_freq
  end

  def get_amount(amount)
    amount = amount.to_s.gsub(/[^\.\d]/,'')
    if amount =~ /[\d]+[\.]?/
        amount = "%.2f" % amount
    else
      logger.info "Amount: #{amount}"
      @errors << "Amount must be numeric (200, 30.50)"
    end
    return amount
  end

  def get_weekday(freq,weekday)
    if freq =~ /every [\d]+ weeks/ || freq == 'weekly'
      if !weekday.blank?
        new_weekday = check_weekday(weekday)
      else
        @errors << "You must set a day of the week for weekly or biweekly items (ie, tuesday)"
      end
    else
      new_weekday = nil
    end
    return new_weekday
  end

  def get_day(freq,day)
    if freq =~ /every [\d]+ months/ || freq == 'monthly' || freq == 'once'
      if !day.blank?
        logger.info "day was not blank"
        new_day = check_days(day)
      else
        @errors << "You must set a day for this items (ie, the 15th)"
      end
    elsif freq == "twice a month"
      if day =~ /([d]+),([d]+)/i || day =~ /([d]+)-([d]+)/i || day =~ /([\d]+[\D]*),([\d]+[\D]*)/i
        new_day = []
        new_day << check_days($1)
        new_day << check_days($2)
      else
        @errors << "For items occuring twice a month, please enter 2 days (1st,15th)"
      end
    else
      new_day = nil
    end
    if new_day.kind_of?(Array)
      new_day.each do |day|
        if day.to_i >31
          @errors << "Day can not be greater than 31"
        end
      end
    else
      if new_day.to_i > 31
        @errors << "Day can not be greater than 31"
      end
    end
    return new_day
  end

  def check_weekday(weekday)
    if weekday =~ /mon/
      weekday = 1
    elsif weekday =~ /tue/
        weekday = 2
    elsif weekday =~ /wed/
        weekday = 3
    elsif weekday =~ /thur/ || weekday =~ /thru/
        weekday = 4
    elsif weekday =~ /fri/
        weekday = 5
    elsif weekday =~ /sat/
        weekday = 6
    elsif weekday =~ /sun/
        weekday = 7
    else
      @errors << "You must set a valid day of the week (ie, Wednesday)"
    end
    return weekday
  end

  def check_days(day)
    #Change Dates into standard format (The 23rd, the 30th == 23, 30)
    if day =~ /([\d]+)/
      day = $1
      logger.info "day was = [d]+, day is #{day}"
    else
      day = day.words_to_numbers
      logger.info "day was in word form, day is #{day}"
    end
    return day
  end

  def get_dates_from_(weekday)
    date_arr = []
    year = Time.now.strftime("%Y").to_i
    month = Time.now.strftime("%m").to_i

    (Date.new(year,month,1) .. Date.new(year,month,-1)).each do |d|
      d = d.to_s(:humanize_date)
      date_arr << d if d.to_date.strftime("%w").to_i == weekday.to_i
    end
    return date_arr
  end

  def is_odd(x)
    x % 2 != 0
  end

  def month_is_even?(month=nil)
    month = Time.now.strftime("%m") if month.blank?
    return false if is_odd(month)
    return true
  end

  def week_is_even?(week=nil)
    week = Time.now.strftime("%W") if week.blank?
    return false if is_odd(week)
    return true
  end

  def create_new_pay_period(begin_date,end_date)
    if !PayPeriod.exists?(:user_id => @current_user.id, :begins => begin_date)
      new_pay_period = @current_user.pay_periods.create(:begins => begin_date, :ends => end_date)
    else
      new_pay_period = PayPeriod.find_by_user_id(@current_user.id, :conditions => ['begins = ?', begin_date])
    end
    return new_pay_period
  end

end

