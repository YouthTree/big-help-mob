class UserSessionsController < ApplicationController

  def index
    redirect_to current_user ? root_url : new_user_session_url
  end

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      if @user_session.new_registration?
        redirect_to page_path(:welcome)
      else
        if @user_session.registration_complete?
          redirect_back_or_default user_path(:current), :notice => "Successfully signed in"
        else
          redirect_to edit_user_path(:current), :notice => "Welcome back! Please complete your registration details to continue"
        end
      end
    else
      redirect_to new_user_session_path, :alert => "Woops! Seems you entered the details incorrectly or we just don't know you..."
    end
  end

  def destroy
    @user_session = current_user_session
    @user_session.destroy if @user_session
    redirect_to root_path, :notice => "Successfully signed out"
  end

end
