require 'spec_helper'

describe UsersController do
  integrate_views

  before(:each) do
    @base_title = Constant::SITE_NAME
  end

  #Delete these examples and add some real ones
  it "should use UsersController" do
    controller.should be_an_instance_of(UsersController)
  end

  describe "GET 'income'" do
    it "should be successful" do
      get 'income'
      response.should be_success
    end

    it "should have the right title" do
      get 'income'
      response.should have_tag("title",@base_title + " | Incomes")
    end
  end

  describe "GET 'bill'" do
    it "should be successful" do
      get 'bill'
      response.should be_success
    end

    it "should have the right title" do
      get 'bill'
      response.should have_tag("title",@base_title + " | Bills")
    end
  end
end

