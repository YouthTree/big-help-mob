class UsersController < ApplicationController

  ssl_required :new,  :create, :edit, :update
  ssl_allowed  :show, :destroy

  before_filter :require_user, :only => [:edit, :destroy, :update]
  before_filter :prepare_user, :except => [:new, :create, :index]
  before_filter :check_authz, :only => [:edit, :destroy, :update]

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_path, :notice => "Thanks for joining!"
    else
      render :action => 'new'
    end
  end

  def edit
    @user.valid?
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_back_or_default user_path(@user), :notice => "Successfully updated your account"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path, :notice => "Successfully closed account"
  end

  def add_rxp_auth
    if @user.save
      flash[:notice] = "Successfully added RPX authentication to this account."
      redirect_to user_path(@user)
    else
      render :action => 'edit'
    end
  end

  protected


  def check_authz
    verb = (params[:action] == "destroy" ? :destroy  : :edit)
    unauthorized! "You aren't the specified user" unless can?(verb, @user)
  end

  def prepare_user
    @user = params[:id] == "current" ? current_user : User.find(params[:id])
    return redirect_to :users, :alert => "I'm sorry, I don't know that user" unless @user.present?
    add_title_variables! :user => @user.to_s
  end

end
