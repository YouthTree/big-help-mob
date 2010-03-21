class MissionsController < ApplicationController
  
  before_filter :prepare_mission, :except => :next
  before_filter :require_user, :except => [:show, :next]
  
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
    @participation = @mission.participation_for(current_user, params[:as])
    if @participation.update_with_conditional_save(params[:mission_participation], params[:as].blank?)
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
    @mission = Mission.viewable.find(params[:id])
    add_title_variables! :mission => @mission.name
  end
  
end
