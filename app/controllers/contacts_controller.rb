class ContactsController < ApplicationController
  
  def new
    @contact = ContactForm.new(params[:contact_form])
  end
  
  def create
    @contact = ContactForm.new(params[:contact_form])
    if @contact.valid?
      @contact.deliver
      redirect_to :root, :notice => tf('contact.thanks')
    else
      render :action => "new"
    end
  end
  
end
