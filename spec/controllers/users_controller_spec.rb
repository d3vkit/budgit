require 'spec_helper'

describe UsersController do

  #Delete these examples and add some real ones
  it "should use UsersController" do
    controller.should be_an_instance_of(UsersController)
  end


  describe "GET 'income'" do
    it "should be successful" do
      get 'income'
      response.should be_success
    end
  end

  describe "GET 'bill'" do
    it "should be successful" do
      get 'bill'
      response.should be_success
    end
  end
end

