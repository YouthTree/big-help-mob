class MissionsController < ApplicationController
  MissionOver = Class.new(StandardError)
  
  rescue_from MissionOver do
    redirect_to @mission, :alert => "You can no longer edit your details for this mission - sorry!"
  end
  
  before_filter :prepare_mission,        :except => :next
  before_filter :require_user_with_note, :only   => [:join]
  before_filter :require_user,           :except => [:show, :next, :join]
  before_filter :prepare_participation,  :only   => [:edit, :update]
  
  def show
    @mission_questions = Question.for(:mission_page).all
  end
  
  def join    
    if @mission.participating?(current_user) && !%w(created awaiting_approval).include?(@mission.participation_for(current_user).try(:state))
      flash[:notice] = "You're already participating in this mission"
      redirect_to @mission
    end
    @captain_questions  = Question.for(:captain_section).all
    @sidekick_questions = Question.for(:sidekick_section).all
  end
  
  def edit
    check_mission_status!
    return redirect_to([:join, @mission]) if @participation.role.blank?
  end
  
  def update
    check_mission_status!
    if @participation.update_attributes(params[:mission_participation])
      redirect_to @mission, :notice => tf('participation.joined')
    else
      render :action => "edit"
    end
  end
  
  protected
  
  def prepare_mission
    return redirect_next_mission if params[:id] == "next" && request.get?
    @mission = Mission.viewable.optimize_viewable.find(params[:id])
    add_title_variables! :mission => @mission.name
  end
  
  def prepare_participation
    @participation = @mission.participation_for(current_user, params[:as])
  end
  
  def redirect_next_mission
    mission = Mission.viewable.next.first
    raise ActiveRecord::RecordNotFound if mission.blank?
    url = case params[:action]
    when "join", "edit"
      [params[:action].to_sym, mission]
    else
      mission
    end
    redirect_to url
  end
  
  def check_mission_status!
    raise MissionOver unless %w(created approved awaiting_approval).include?(@participation.state) && %w(preparing approved).include?(@mission.state)
  end
  
  def require_user_with_note
    unless logged_in?
      store_location
      redirect_to sign_in_path, :notice => "Before you can join this mission, you'll need to sign in or create a Big Help Mob account."
      return false
    end
  end
  
end
