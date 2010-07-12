# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include SessionsHelper
  include BillsHelper

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

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
    params[:bill][:day] = new_day
    params[:bill][:weekday] = new_weekday
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
    if weekday =~ /(mon)/
      weekday = 1
    elsif weekday =~ /(tue)/
        weekday = 2
    elsif weekday =~ /(wed)/
        weekday = 3
    elsif weekday =~ /(thurs)/
        weekday = 4
    elsif weekday =~ /(fri)/
        weekday = 5
    elsif weekday =~ /(sat)/
        weekday = 6
    elsif weekday =~ /(sun)/
        weekday = 7
    else
      flash_error_and_render("You must set a valid day of the week (ie, Wednesday)")
    end
  end

  def check_days(day)
    #Change Dates into standard format (The 23rd, the 30th == 23,30)
    return day = day.gsub!(/[\D]+/,"").to_i

    #dates.each do |date|
    #  date.gsub!(/[\D]+/,"").to_i
    #end
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

end

