class FundsController < ApplicationController

  def index
    @funds = Fund.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @funds }
    end
  end

  def show
    @fund = Fund.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fund }
    end
  end

  def new
    @fund = Fund.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fund }
    end
  end

  def edit
    @fund = Fund.find(params[:id])
  end

  def create
    @fund = Fund.new(params[:fund])

    respond_to do |format|
      if @fund.save
        Flash[:notice] = "Fund was successfully created!"
        format.html { redirect_to @fund }
        format.xml  { render :xml => @fund, :status => :created, :location => @fund }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @fund.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @fund = Fund.find(params[:id])

    respond_to do |format|
      if @fund.update_attributes(params[:fund])
        Flash[:notice] = "Fund was successfully updated!"
        format.html { redirect_to @fund }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @fund.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @fund = Fund.find(params[:id])
    @fund.destroy

    respond_to do |format|
      format.html { redirect_to(funds_url) }
      format.xml  { head :ok }
    end
  end
end

