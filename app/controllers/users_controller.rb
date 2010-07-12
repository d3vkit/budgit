class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:index, :destroy]

  def index
    @title = "All Users"
    @users = User.paginate :page => params[:page]

    respond_to do |format|
      format.html #index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def show
    @user = User.find(params[:id])
    @bills = @user.bills.find(:all)
    @title = CGI.escapeHTML(@user.name)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def new
    @title = "Sign Up"
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def edit
    @title = "Edit User"
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @title = "Settings"

    respond_to do |format|
      if !params[:user][:admin].blank? && current_user.admin?
        @user.admin = params[:user][:admin]
        @user.save
      end
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'Settings successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    User.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to(users_url, :success => "User Destroyed, Sire") }
      format.xml  { head :ok }
    end
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user) || current_user.admin?
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end

