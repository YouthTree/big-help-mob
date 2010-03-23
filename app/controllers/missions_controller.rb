class MissionsController < ApplicationController
  
  before_filter :prepare_mission, :except => :next
  before_filter :require_user, :except => [:show, :next]
  before_filter :prepare_participation, :only => [:edit, :update]
  
  def show
  end
  
  def join    
    if @mission.participating?(current_user)
      flash[:notice] = "You're already participating in this mission"
      redirect_to @mission
    end
    # Renders a page with the selector
  end
  
  def edit
  end
  
  def update
    
    if @participation.update_attributes(params[:mission_participation])
      redirect_to @mission, :notice => tf('participation.joined')
    else
      render :action => "edit"
    end
  end
  
  def next
    @mission = Mission.next.first
    if @mission.blank?
      raise ActiveRecord::RecordNotFound
    else
      redirect_to @mission
    end
  end
  
  protected
  
  def prepare_mission
    @mission = Mission.viewable.optimize_viewable.find(params[:id])
    add_title_variables! :mission => @mission.name
  end
  
  def prepare_participation
    @participation = @mission.participation_for(current_user, params[:as])
  end
  
end
