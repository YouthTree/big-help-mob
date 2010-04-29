class Admin::EmailsController < AdminController
  
  def new
    @email = Email.new
  end
  
  def create
    @email = Email.new(params[:email])
    if @email.save
      redirect_to :new_admin_email, :notice => "Email sent - thanks!"
    else
      render :action => "new"
    end
  end
  
end