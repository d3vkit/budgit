class BillsController < ApplicationController
  before_filter :authenticate
  before_filter :change_words, :only => [:create, :update]
  before_filter :define_dates

  def index
    @title = "Bills"
    @bills = Bill.find_all_by_month(@current_month)
    @bills = @bills.sort_by { |bill| bill.day.to_i }

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
    @submit_txt = "Create"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bill }
    end
  end

  def edit
    @title = "Edit Bill"
    @bill = Bill.find(params[:id])
    @submit_txt = "Change"
  end

  def create
    #All bills are saved in the recurring_bills table (once), and then are saved in the bills table (as much as necessary)
    #Weekly bills dates are found and then a new bill is created for the current month for each date.
    #Monthly bills are created for the year on the users given date.
    #A cron will sweep the recurring bills table and create new bills when necessary.

    is_weekly = false
    is_monthly = false

    respond_to do |format|
      if @errors.blank?
        logger.info "no errors, supposedly; going to save"

        if params[:bill][:frequency] == 'once'
          @bill = Bill.new(params[:bill])
          @bill.year = @current_year
          @bill.month = @current_month
          @bill.occurs_once = true
          if @bill.save
            format.html { redirect_to(bills_path, :notice => 'Bill was successfully created.') }
            format.xml  { render :xml => bills_path, :status => :created, :location => @bill }
          else
            format.html { render :action => "new" }
            format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
          end
        else

          @bill = current_user.recurring_bills.build(params[:bill])
          @bill.year = @current_year

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
            elsif @bill.frequency == "twice a month"
              is_twice_a_month = true
            elsif @bill.frequency =~ /every 2 weeks/i
              is_biweekly = true
            elsif @bill.frequency =~ /every 2 months/i
              is_bimonthly = true
            end

            if is_weekly || is_biweekly
              weekday_dates = get_dates_from_(@bill.weekday)
              weekday_dates.each do |day|
                week_in_year = day.to_time.strftime("%W").to_i
                if is_weekly || week_is_even?(week_in_year) && @bill.alternator == 'even' || !week_is_even?(week_in_year) && @bill.alternator == 'odd'
                  this_day = day.to_date.strftime("%d")
                  this_month = day.to_date.strftime("%m")
                  new_bill = duplicate_recurring_bill(@bill,this_day.to_i,this_month.to_i)
                  new_bill.year = @current_year

                  begin_date = Date.new(new_bill.year,new_bill.month,this_day.to_i)
                  end_date = Date.new(new_bill.year,new_bill.month,this_day.to_i).to_time.advance(:weeks => 1, :days => -1).to_date
                  new_pay_period = create_new_pay_period(begin_date,end_date)

                  new_bill.pay_period_id = new_pay_period.id

                  new_bill.save
                end
              end
            elsif is_monthly || is_twice_a_month
              bill_months = (@last_month..@next_month).to_a
              bill_months.each do |this_month|
                if is_twice_a_month
                  new_bill = duplicate_recurring_bill(@bill,@bill.day[0].to_i,this_month.to_i)
                  new_bill.year = @current_year

                  begin_date = Date.new(new_bill.year,new_bill.month,@bill.day[0].to_i)
                  end_date = Date.new(new_bill.year,new_bill.month,@bill.day[1].to_i).to_time.advance(:days => -1).to_date
                  new_pay_period = create_new_pay_period(begin_date,end_date)

                  new_bill.pay_period_id = new_pay_period.id

                  new_bill2 = duplicate_recurring_bill(@bill,@bill.day[1].to_i,this_month.to_i)
                  new_bill2.year = @current_year

                  begin_date = Date.new(new_bill2.year,new_bill2.month,@bill.day[1].to_i)
                  end_date = Date.new(new_bill2.year,new_bill2.month,@bill.day[0].to_i).to_time.advance(:months => 1, :days => -1).to_date
                  new_pay_period2 = create_new_pay_period(begin_date,end_date)

                  new_bill2.pay_period_id = new_pay_period2.id

                  if !new_bill.save || !new_bill2.save
                    format.html { render :action => "new" }
                    format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
                  end
                else
                  new_bill = duplicate_recurring_bill(@bill,@bill.day.to_i,this_month.to_i)
                  new_bill.year = @current_year

                  begin_date = Date.new(new_bill.year,new_bill.month,@bill.day.to_i)
                  end_date = Date.new(new_bill.year,new_bill.month,@bill.day.to_i).to_time.advance(:months => 1, :days => -1).to_date
                  new_pay_period = create_new_pay_period(begin_date,end_date)

                  new_bill.pay_period_id = new_pay_period.id

                  if !new_bill.save
                    format.html { render :action => "new" }
                    format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
                  end
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
      else
        errors = @errors.join('<br />') if @errors.kind_of?(Array)
        flash[:error] = errors
        @bill = Bill.new(params[:bill])
        @submit_txt = "Create"
        params[:action] = 'new'
        format.html { render :action => "new" }
        format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
      end
    end

  end

  def duplicate_recurring_bill(bill, day=nil, month=nil)
    #for recurring bills, we duplicate the bill - weekly bills will have days passed in, and current month is used; monthly has month and day

    new_bill = current_user.bills.build(bill.attributes)
    if !day.blank? && !month.blank?
      end_of_month = Date.new(@current_year,month).end_of_month.to_time.strftime("%d").to_i
      if day > end_of_month
        new_bill.day = end_of_month
      else
        new_bill.day = day
      end
    else
      new_bill.day = day if !day.blank?
    end
    new_bill.recurring_bill_id = bill.id
    month.blank? ? new_bill.month = @current_month : new_bill.month = month
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

  def flash_error_and_render(errors)
    logger.info "flash error and render called with : #{errors}, commit: #{@commit}"
    @bill = current_user.bills.build(@params)
    errors = errors.join('<br />') if errors.kind_of?(Array)
    flash[:error] = errors
    if @commit == "create"
      render :template => 'bills/new' and return
    elsif @commit == "update"
      render :template => 'bills/edit' and return
    end
  end

end

