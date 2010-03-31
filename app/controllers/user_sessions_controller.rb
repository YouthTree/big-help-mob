class UserSessionsController < ApplicationController

  ssl_required :new,  :create
  ssl_allowed  :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      if @user_session.new_registration?
        redirect_to edit_user_path(:current), :notice => tf('profile.welcome')
      else
        if @user_session.registration_complete?
          redirect_back_or_default user_path(:current), :notice => tf('general.signed_in')
        else
          redirect_to edit_user_path(:current), :notice => tf('profile.incomplete')
        end
      end
    else
      redirect_to sign_in_path(:traditional => true), :alert => tf('profile.unknown_user')
    end
  end

  def destroy
    @user_session = current_user_session
    @user_session.destroy if @user_session
    redirect_to root_path, :notice => tf('general.signed_out')
  end

end
