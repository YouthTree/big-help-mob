class Admin::EmailsController < AdminController
  
  def new
    @email = Email.new
  end
  
  def create
    @email = Email.new(params[:email])
    if @email.save
      redirect_to :queued_admin_emails
    else
      render :action => "new"
    end
  end
  
  def queued
  end
  
end