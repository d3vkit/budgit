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
      change_bill_words
    else
      redirect_to new_bill_path
    end
  end

  def change_bill_words
    @params = params[:bill]
    @frequency = params[:bill][:frequency].downcase
    @weekday = params[:bill][:weekday].downcase
    @month = params[:bill][:month].downcase
    @day = params[:bill][:day].downcase
    @commit = params[:commit].downcase

    #Change @frequency into standard format (each month == Monthly)
    #Formats are: weekly, every # weeks
    if @frequency != "monthly" && @frequency != "daily" && @frequency != "hourly" && @frequency != "weekly" && @frequency != "yearly"
      if @frequency =~ /every ([\d]+) ([a-z]+)/
        if $1 == '1' || $1 == 'one'
          @frequency = $2.singularize.continuous
        elsif $1 >= '3' || $1 == "three" || $1 == "four" || $1 == "five" || $1 == "six" || $1 == "seven" || $1 == "third" || $1 == "fourth" || $1 == "fifth" || $1 == "sixth" || $1 == "seventh"
          flash_error_and_render("Sorry, that frequency is out of range (can not happen more than twice a #{$2.singularize})")
        elsif $2.singularize != 'year'
          @frequency = "every 2 #{$2.singularize.pluralize}"
        else
          flash_error_and_render("Sorry, that frequency is out of range (more than 1 year in advance)")
        end
      elsif @frequency =~ /every ([a-z]+)/ || @frequency =~ /each ([a-z]+)/
        if $1 == 'week' || $1 == 'day' || $1 == 'month' || $1 == 'year' || $1 == 'hour'
          @frequency = $1.continuous
        end
      elsif @frequency =~ /bi([a-z]+)/
        @frequency = "every 2 "+$1.uncontinuous.pluralize
      elsif @frequency =~ /once a ([a-z]+)/
        @frequency = $1.singularize.continuous
      else
        flash_error_and_render("Frequency must be in the form of 'Every Week', 'Each Day', 'Monthly', etc")
      end
    end

    new_weekday,new_day = check_dates(@frequency)

    params[:bill][:frequency] = @frequency.downcase
    params[:bill][:day] = new_day.to_i if new_day.to_i != 0
    params[:bill][:weekday] = new_weekday.to_i if new_weekday.to_i != 0
    params[:bill][:month] = @month
  end

  def check_dates(freq)
    if freq =~ /every [\d]+ weeks/ || freq == 'weekly'
      if !@weekday.blank?
        new_weekday = check_weekday(@weekday)
        new_day = ""
        return new_weekday, new_day
      else
        flash_error_and_render("You must set a day of the week for weekly or biweekly bills (ie, tuesday)")
      end
    elsif freq =~ /every [\d]+ months/ || freq == 'monthly'
      if !@day.blank?
        new_day = check_days(@day)
        new_weekday = ""
        return new_weekday, new_day
      else
        flash_error_and_render("You must set a day for this bill (ie, the 15th)")
      end
    end
  end

  def check_weekday(weekday)
    if weekday =~ /mon/
      weekday = 1
    elsif weekday =~ /tue/
        weekday = 2
    elsif weekday =~ /wed/
        weekday = 3
    elsif weekday =~ /thur/ || weekday =~ /thrus/
        weekday = 4
    elsif weekday =~ /fri/
        weekday = 5
    elsif weekday =~ /sat/
        weekday = 6
    elsif weekday =~ /sun/
        weekday = 7
    else
      flash_error_and_render("You must set a valid day of the week (ie, Wednesday)")
    end
  end

  def check_days(day)
    #Change Dates into standard format (The 23rd, the 30th == 23, 30)
    if day =~ /[\D]*([\d])[\D]*/
      day = $1
    else
      day = day.words_to_numbers
    end
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

  def flash_error_and_render(error)
    @bill = current_user.bills.build(@params)
    flash[:error] = error
    if @commit == "create"
      render :action => :new
    elsif @commit == "update"
      render :action => :edit
    end
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

end

