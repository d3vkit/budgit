class BillsController < ApplicationController
  before_filter :authenticate
  before_filter :change_words, :only => [:create, :update]

  #before_filter :remove_trailing_zeros, :only => [:create]

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

  def new
    @bill = Bill.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bill }
    end
  end

  def edit
    @bill = Bill.find(params[:id])
  end

  def create
    #All bills are saved in the recurring_bills table (once), and then are saved in the bills table (as much as necessary)
    #Weekly bills dates are found and then a new bill is created for the current month for each date.
    #Monthly bills are created for the year on the users given date.
    #A cron will sweep the recurring bills table and create new bills when necessary.

    is_weekly = false
    is_monthly = false
    @current_day = Time.now.strftime("%d").to_i
    @current_month = Time.now.strftime("%m").to_i
    @current_year = Time.now.strftime("%Y").to_i

    @bill = current_user.recurring_bills.build(params[:bill])
    @bill.year = @current_year

    respond_to do |format|
      if @bill.save

        if @bill.frequency =~ /weekly/i
          if !params[:bill][:weekday].blank?
            if params[:bill][:day].blank?
              is_weekly = true
            else
              format.html { render :action => "new", :notice => 'Frequency was set to weekday, but a date was filled in - are you sure this isn\'t monthly?' }
              format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
            end
          else
            format.html { render :action => "new", :notice => 'You must specify a weekday for weekly bills! (such as, Thursday)' }
            format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
          end
        elsif @bill.frequency =~ /monthly/i
          is_monthly = true
        elsif @bill.frequency =~ /every ([\d]+) week/i
          is_biweekly = true
        elsif @bill.frequency =~ /every ([\d]+) month/i
          is_bimonthly = true
        end

        if is_weekly
          weekday_dates = get_days_from_(@bill.weekday)
          weekday_dates.each do |day|
            this_day = day.to_date.strftime("%d")
            new_bill = duplicate_recurring_bill(@bill,this_day)
            new_bill.year = @current_year
            if !new_bill.save
              format.html { render :action => "new" }
              format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
            end
          end
        elsif is_monthly
          bill_months = (1..12).to_a
          bill_months.each do |this_month|
            new_bill = duplicate_recurring_bill(@bill,@bill.day,this_month)
            new_bill.year = @current_year
            if !new_bill.save
              format.html { render :action => "new" }
              format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
            end
          end
        end

        format.html { redirect_to(bills_path, :notice => 'Bill was successfully created.') }
        format.xml  { render :xml => bills_path, :status => :created, :location => @bill }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
      end
    end

  end

  def duplicate_recurring_bill(bill, day=nil, month=nil)
    #for recurring bills, we duplicate the bill - weekly bills will have days passed in, and current month is used; monthly has month and day
    new_bill = current_user.bills.build(bill.attributes)
    new_bill.day = day.to_i if !day.blank?
    new_bill.recurring_bill_id = bill.id
    month.blank? ? new_bill.month = @current_month : new_bill.month = month.to_i
    return new_bill
  end

  def update
    @bill = Bill.find(params[:id])

    respond_to do |format|
      if @bill.update_attributes(params[:bill])
        format.html { redirect_to(@bill, :notice => 'Bill was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @bill = Bill.find(params[:id])
    @bill.destroy

    respond_to do |format|
      format.html { redirect_to(bills_url) }
      format.xml  { head :ok }
    end
  end

  def bill_occurance

  end
end

