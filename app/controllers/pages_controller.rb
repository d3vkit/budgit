class PagesController < ApplicationController
  before_filter :define_dates
  def home
    @title = "Home"
    @items = []
    @bills = Bill.find( :all, :include => :pay_period, :conditions => [ 'pay_periods.user_id = ? AND pay_periods.begins >= ? AND pay_periods.ends <= ?', current_user.id, @current_date.to_time.advance(:months => -1).to_date, @current_date.to_time.advance(:months => 1).to_date ] )
    @incomes = Income.find( :all, :include => :pay_period, :conditions => [ 'pay_periods.user_id = ? AND pay_periods.begins >= ? AND pay_periods.ends <= ?', current_user.id, @current_date.to_time.advance(:months => -1).to_date, @current_date.to_time.advance(:months => 1).to_date ] )

    @items << @bills
    @items << @incomes

    @items.flatten!
    @items = @items.sort_by { |item| [item.month.to_i, item.day.to_i] }


  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

  def help
    @title = "Help"
  end

end

