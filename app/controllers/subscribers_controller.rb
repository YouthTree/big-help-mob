class SubscribersController < ApplicationController

  layout :compute_layout

  def new
    @subscriber = Subscriber.new
  end

  def create
    @subscriber = Subscriber.new(params[:subscriber])
    if @subscriber.save
      if request.xhr?
        head :ok
      else
        redirect_to :root, :notice => tf('subscriber.created')
      end
    else
      render :action => 'new'
    end
  end

  protected

  def compute_layout
    request.xhr? ? false : 'application'
  end

end
