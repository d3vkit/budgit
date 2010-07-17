class RecurringBillsController < ApplicationController
  before_filter :authenticate
  before_filter :change_words, :only => [:create]

  def index

  end

  def show

  end

end

