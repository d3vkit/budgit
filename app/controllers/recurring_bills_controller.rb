class RecurringBillsController < ApplicationController
  before_filter :authenticate
  before_filter :change_words, :only => [:create]

  def index
    @title = "Bills"
    @monthly_bills = []
    @weekly_bills = []
    @current_month = Time.now.strftime("%m").to_i

    @bills = Bill.all(:order => 'day', :conditions => ['month = ?', @current_month])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bills }
    end
  end

  def show
    @bill = Bill.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bill }
    end
  end

end

