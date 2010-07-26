class RecurringIncomesController < ApplicationController
  before_filter :authenticate
  before_filter :change_words, :only => [:create, :update]

  def index
    @title = "Recurring Incomes"
    @incomes = RecurringIncome.all(:order => 'created_at ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @incomes }
    end
  end

  def edit
    @title = "Edit Recurring income"
    @income = RecurringIncome.find(params[:id])
    @submit_txt = "Change"
  end

  def update
    @income = RecurringIncome.find(params[:id])

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

  def show

  end

  def destroy
    @income = RecurringIncome.find(params[:id])
    @income.destroy

    respond_to do |format|
      format.html { redirect_to(incomes_url) }
      format.xml  { head :ok }
    end
  end
end

