class PayPeriodsController < ApplicationController
  # GET /pay_periods
  # GET /pay_periods.xml
  def index
    @pay_periods = PayPeriod.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pay_periods }
    end
  end

  # GET /pay_periods/1
  # GET /pay_periods/1.xml
  def show
    @pay_period = PayPeriod.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pay_period }
    end
  end

  # GET /pay_periods/new
  # GET /pay_periods/new.xml
  def new
    @pay_period = PayPeriod.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pay_period }
    end
  end

  # GET /pay_periods/1/edit
  def edit
    @pay_period = PayPeriod.find(params[:id])
  end

  # POST /pay_periods
  # POST /pay_periods.xml
  def create
    @pay_period = PayPeriod.new(params[:pay_period])

    respond_to do |format|
      if @pay_period.save
        format.html { redirect_to(@pay_period, :notice => 'PayPeriod was successfully created.') }
        format.xml  { render :xml => @pay_period, :status => :created, :location => @pay_period }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pay_period.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pay_periods/1
  # PUT /pay_periods/1.xml
  def update
    @pay_period = PayPeriod.find(params[:id])

    respond_to do |format|
      if @pay_period.update_attributes(params[:pay_period])
        format.html { redirect_to(@pay_period, :notice => 'PayPeriod was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pay_period.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pay_periods/1
  # DELETE /pay_periods/1.xml
  def destroy
    @pay_period = PayPeriod.find(params[:id])
    @pay_period.destroy

    respond_to do |format|
      format.html { redirect_to(pay_periods_url) }
      format.xml  { head :ok }
    end
  end
end
