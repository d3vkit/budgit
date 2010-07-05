require 'spec_helper'

describe UsersController do
  integrate_views

  #Delete these examples and add some real ones
  it "should use UsersController" do
    controller.should be_an_instance_of(UsersController)
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      repsonse.should_have_tag("title","Home | Budgit")
    end
  end


  describe "GET 'income'" do
    it "should be successful" do
      get 'income'
      response.should be_success
    end

    it "should have the right title" do
      get 'income'
      response.should_have_tag("title","Incomes | Budgit")
    end
  end

  describe "GET 'bill'" do
    it "should be successful" do
      get 'bill'
      response.should be_success
    end

    it "should have the right title" do
      get 'bill'
      response.should_have_tag("title","Bills | Budgit")
    end
  end
end

