class RecurringBillsController < ApplicationController
  before_filter :authenticate
  before_filter :change_words, :only => [:create, :update]
  before_filter :define_dates

  def index
    @title = "Recurring Bills"
    @bills = RecurringBill.all(:order => 'created_at ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bills }
    end
  end

  def edit
    @title = "Edit Recurring Bill"
    @bill = RecurringBill.find(params[:id])
    @submit_txt = "Change"
  end

  def update
    @bill = RecurringBill.find(params[:id])

    respond_to do |format|
      if @bill.update_attributes(params[:recurring_bill])
        format.html { redirect_to(@bill, :notice => 'Bill was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @recurring_bill = RecurringBill.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bill }
    end
  end

  def destroy
    @bill = RecurringBill.find(params[:id])
    @bill.destroy

    respond_to do |format|
      format.html { redirect_to(bills_url) }
      format.xml  { head :ok }
    end
  end

end

