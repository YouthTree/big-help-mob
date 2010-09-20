class PasswordResetsController < ApplicationController
  
  ssl_required :new,  :create, :edit, :update
  
  before_filter :require_no_user
  before_filter :prepare_password_reset, :only => [:edit, :update]
  
  def new
    @password_reset = PasswordReset.new
  end
  
  def create
    @password_reset = PasswordReset.new(params[:password_reset])
    if @password_reset.save
      redirect_to :sign_in, :notice => tf('password_resets.reset_sent')
    else
      flash.now[:alert] = tf('password_resets.unable_to_reset')
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @password_reset.update params[:password_reset]
      redirect_to user_path(:current), :notice => tf('password_resets.reset_complete')
    else
      render :action => "edit"
    end
  end
  
  protected
  
  def prepare_password_reset
    @password_reset = PasswordReset.find(params[:id])
    if @password_reset.blank?
      redirect_to :new_password_reset, :alert => tf('password_resets.invalid_url')
      return false
    end
  end
  
end
