class IncomesController < ApplicationController
  before_filter :authenticate
  before_filter :change_words, :only => [:create, :update]
  before_filter :define_dates

  def index
    @title = "Incomes"
    @incomes = Income.find_all_by_month(@current_month)
    @incomes = @incomes.sort_by { |income| income.day.to_i }

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @incomes }
    end
  end

  def show
    @income = Income.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @income }
    end
  end

  def new
    @income = Income.new
    @submit_txt = "Create"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @income }
    end
  end

  def edit
    @title = "Edit Income"
    @income = Income.find(params[:id])
    @submit_txt = "Change"
  end

  def create
    #All incomes are saved in the recurring_incomes table (once), and then are saved in the incomes table (as much as necessary)
    #Weekly incomes dates are found and then a new income is created for the current month for each date.
    #Monthly incomes are created for the year on the users given date.
    #A cron will sweep the recurring incomes table and create new incomes when necessary.

    is_weekly = false
    is_monthly = false

    respond_to do |format|
      if @errors.blank?
        logger.info "no errors, supposedly; going to save"

        if params[:income][:frequency] == 'once'
          @income = Income.new(params[:income])
          @income.year = @current_year
          @income.month = @current_month
          @income.occurs_once = true
          if @income.save
            format.html { redirect_to(incomes_path, :notice => 'income was successfully created.') }
            format.xml  { render :xml => incomes_path, :status => :created, :location => @income }
          else
            format.html { render :action => "new" }
            format.xml  { render :xml => @income.errors, :status => :unprocessable_entity }
          end
        else

          @income = current_user.recurring_incomes.build(params[:income])
          @income.year = @current_year

          if @income.save
            if @income.frequency =~ /weekly/i
              if !params[:income][:weekday].blank?
                if params[:income][:day].blank?
                  is_weekly = true
                else
                  format.html { render :action => "new", :notice => 'Frequency was set to weekday, but a date was filled in - are you sure this isn\'t monthly?' }
                  format.xml  { render :xml => @income.errors, :status => :unprocessable_entity }
                end
              else
                format.html { render :action => "new", :notice => 'You must specify a weekday for weekly incomes! (such as, Thursday)' }
                format.xml  { render :xml => @income.errors, :status => :unprocessable_entity }
              end
            elsif @income.frequency =~ /monthly/i
              is_monthly = true
            elsif @income.frequency == "twice a month"
              is_twice_a_month = true
            elsif @income.frequency =~ /every 2 weeks/i
              is_biweekly = true
            elsif @income.frequency =~ /every 2 months/i
              is_bimonthly = true
            end

            if is_weekly || is_biweekly
              weekday_dates = get_dates_from_(@income.weekday)
              weekday_dates.each do |day|
                week_in_year = day.to_time.strftime("%W").to_i
                if is_weekly || week_is_even?(week_in_year) && @income.alternator == 'even' || !week_is_even?(week_in_year) && @income.alternator == 'odd'
                  this_day = day.to_date.strftime("%d")
                  this_month = day.to_date.strftime("%m")
                  new_income = duplicate_recurring_income(@income,this_day.to_i,this_month.to_i)
                  new_income.year = @current_year

                  begin_date = Date.new(new_income.year,new_income.month,day)
                  end_date = Date.new(new_income.year,new_income.month,day).to_time.advance(:weeks => 1, :days => -1).to_date
                  new_pay_period = create_new_pay_period(begin_date,end_date)

                  new_income.pay_period_id = new_pay_period.id

                  new_income.save
                end
              end
            elsif is_monthly || is_twice_a_month
              logger.info 'income is monthly or twice a month'
              income_months = (@last_month..@next_month).to_a
              income_months.each do |array_month|
                logger.info "making income for month #{array_month}"
                if is_twice_a_month
                  logger.info "income is twice a month"
                  new_income = duplicate_recurring_income(@income,@income.day[0].to_i,array_month.to_i)
                  new_income.year = @current_year
                  begin_date = Date.new(new_income.year,new_income.month,@income.day[0].to_i)
                  end_date = Date.new(new_income.year,new_income.month,@income.day[1].to_i).to_time.advance(:days => -1).to_date
                  new_pay_period = create_new_pay_period(begin_date,end_date)

                  new_income.pay_period_id = new_pay_period.id

                  new_income2 = duplicate_recurring_income(@income,@income.day[1].to_i,array_month.to_i)
                  new_income2.year = @current_year
                  begin_date = Date.new(new_income2.year,new_income2.month,@income.day[1].to_i)
                  end_date = Date.new(new_income2.year,new_income2.month,@income.day[0].to_i).to_time.advance(:months => 1, :days => -1).to_date
                  new_pay_period2 = create_new_pay_period(begin_date,end_date)

                  new_income2.pay_period_id = new_pay_period2.id

                  logger.info 'saving new incomes'
                  if !new_income.save || !new_income2.save
                    logger.info "unable to save, errors: #{@income.errors}"
                    format.html { render :action => "new" }
                    format.xml  { render :xml => @income.errors, :status => :unprocessable_entity }
                  end
                else
                  logger.info "income is monthly"
                  new_income = duplicate_recurring_income(@income,@income.day.to_i,array_month.to_i)
                  new_income.year = @current_year
                  begin_date = Date.new(new_income.year,new_income.month,@income.day.to_i)
                  end_date = Date.new(new_income.year,new_income.month,@income.day.to_i).to_time.advance(:months => 1, :days => -1).to_date
                  new_pay_period = create_new_pay_period(begin_date,end_date)

                  new_income.pay_period_id = new_pay_period.id

                  logger.info 'attempting to save income'
                  if !new_income.save
                    format.html { render :action => "new" }
                    format.xml  { render :xml => @income.errors, :status => :unprocessable_entity }
                  end
                end
              end

            end


            format.html { redirect_to(incomes_path, :notice => 'Income was successfully created.') }
            format.xml  { render :xml => incomes_path, :status => :created, :location => @income }
          else
            format.html { render :action => "new" }
            format.xml  { render :xml => @income.errors, :status => :unprocessable_entity }
          end
        end
      else
        errors = @errors.join('<br />') if @errors.kind_of?(Array)
        flash[:error] = errors
        @income = income.new(params[:income])
        @submit_txt = "Create"
        params[:action] = 'new'
        format.html { render :action => "new" }
        format.xml  { render :xml => @income.errors, :status => :unprocessable_entity }
      end
    end

  end

  def duplicate_recurring_income(income, day=nil, month=nil)
    #for recurring incomes, we duplicate the income - weekly incomes will have days passed in, and current month is used; monthly has month and day

    new_income = current_user.incomes.build(income.attributes)
    if !day.blank? && !month.blank?
      end_of_month = Date.new(@current_year,month).end_of_month.to_time.strftime("%d").to_i
      if day > end_of_month
        new_income.day = end_of_month
      else
        new_income.day = day
      end
    else
      new_income.day = day if !day.blank?
    end
    new_income.recurring_income_id = income.id
    month.blank? ? new_income.month = @current_month : new_income.month = month
    return new_income
  end

  def update
    @income = Income.find(params[:id])

    respond_to do |format|
      if @income.update_attributes(params[:income])
        format.html { redirect_to(@income, :notice => 'Income was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @income.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @income = Income.find(params[:id])
    @income.destroy

    respond_to do |format|
      format.html { redirect_to(incomes_url) }
      format.xml  { head :ok }
    end
  end
end

