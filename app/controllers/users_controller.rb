class UsersController < ApplicationController

  ssl_required :new,  :create, :edit, :update
  ssl_allowed  :show, :destroy

  before_filter :require_user, :only => [:edit, :destroy, :update, :welcome]
  before_filter :prepare_user, :except => [:new, :create, :index, :welcome]
  before_filter :check_authz, :only => [:edit, :destroy, :update]

  def show
    @participations = @user.mission_participations.viewable_by(current_user).all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_back_or_default welcome_users_path, :notice => tf('signup.thanks')
    else
      render :action => 'new'
    end
  end

  def edit
    flash[:profile_notice] = tf('profile.full_incomplete')
    @user.valid?
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_back_or_default user_path(@user), :notice => tf('account.updated')
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path, :notice => tf('account.destroyed')
  end

  def add_rxp_auth
    if @user.save
      flash[:notice] = tf('account.added_rpx_auth')
      redirect_to user_path(@user)
    else
      render :action => 'edit'
    end
  end

  def welcome
  end

  protected

  def check_authz
    verb = (params[:action] == "destroy" ? :destroy  : :edit)
    unauthorized! tf('account.different_user') unless can?(verb, @user)
  end

  def prepare_user
    @user = params[:id] == "current" ? current_user : User.find(params[:id])
    return redirect_to :users, :alert => tf('account.unknown_user') unless @user.present?
    add_title_variables! :user => @user.to_s
  end

end
