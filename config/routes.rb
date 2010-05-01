Bighelpmob::Application.routes.draw do |map|
  
  # TODO: Uncomment when rails routing is broken.
  # scope :path => '/admin/resque', :name_prefix => :resque do
  #   server = Resque::Server.new
  #   root :to => server
  #   match '*', :to =>  server
  # end
  
  namespace :admin do
    
    resources :emails, :only => [:new, :create] do
      collection do
        get :queued
      end
    end
    resources :users do
      resources :mission_participations, :path => 'participations'
    end
    resources :missions do
      resources :mission_participations, :path => 'participations'
      resources :dynamic_templates,      :path => 'dynamic-templates'
      member do
        get :dashboard
        get :report
      end
    end
    resources :organisations
    resources :pickups
    resources :contents
    resources :questions do
      collection do
        post :reorder
      end
    end
    
    match '', :to => 'dashboard#index', :as => :dashboard
  end
  
  resources :user_session, :path => 'user-sessions'
  
  resources :password_resets, :path => 'password-resets'
  
  get   'sign-in', :to => 'user_sessions#new', :as => :sign_in
  post  'sign-in', :to => 'user_sessions#create'
  match 'sign-out', :to => 'user_sessions#destroy', :as => :sign_out
  
  resources :users do
    collection do
      get :welcome
    end
    member do
      post :add_rxp_auth
    end
  end
  
  get 'missions/:id/edit/:as', :to => 'missions#edit', :as => :edit_mission_with_role
  
  resources :missions do
    member { get :join }
  end
  
  get 'contact-us',  :to => 'contacts#new', :as => :contact_us
  post 'contact-us', :to => 'contacts#create'
  
  %w(about privacy_policy terms_and_conditions).each do |page|
    get page.dasherize, :to => "pages##{page}", :as => page.to_sym
  end
  
  root :to => "pages#index"
  
  get 'errors/not-found',             :to => 'errors#not_found'
  get 'errors/internal-server-error', :to => 'errors#general_exception'
end
