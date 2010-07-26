class SessionsController < ApplicationController
  def new
    @title = "Sign In"
  end

  def create
    user = User.authenticate(params[:session][:email],params[:session][:password])
    if user.nil?
      @title = "Sign In"
      flash.now[:error] = "Username and/or password incorrect"
      render "new"
    else
      sign_in user
      redirect_back_or bills_path
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end

