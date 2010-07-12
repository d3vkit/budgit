class BillsController < ApplicationController
  before_filter :authenticate
  before_filter :change_words, :only => [:create, :edit]

  #before_filter :remove_trailing_zeros, :only => [:create]

  def index
    @title = "Bills"
    @monthly_bills = []
    @weekly_bills = []
    year = Time.now.strftime("%Y").to_i
    month = Time.now.strftime("%m").to_i


    @bills = Bill.all

    @bills.each do |bill|
      freq = bill.frequency
      weekly_bill_dates = []

      if freq == 'monthly'
        @monthly_bills << bill
      elsif freq == 'weekly'
        logger.info "weekly - getting dates"
        weekly_bill_dates = bill_dates(bill.weekday.to_i,year,month)
        weekly_bill_dates.each do |d|
          logger.info "Bill date: #{d}"
        end
        @weekly_bills << bill
      elsif freq == "bimonthly"
        @bimonthly_bill << bill
      end



    end

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
    @bill = current_user.bills.build(params[:bill])

    respond_to do |format|
      if @bill.save
        format.html { redirect_to(@bill, :notice => 'Bill was successfully created.') }
        format.xml  { render :xml => @bill, :status => :created, :location => @bill }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
      end
    end
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

  def bill_dates(weekday,year,month)
    date_arr = []
    (Date.new(year,month,1) .. Date.new(year,month,-1)).each do |d|
      d = d.to_s(:humanize_date)
      date_arr << d if d.to_date.strftime("%w").to_i == weekday.to_i
    end
    return date_arr
  end

end

