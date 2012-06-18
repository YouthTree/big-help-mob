BigHelpMob::Application.routes.draw do
  mount Resque::Server.new, :at => "/resque"

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
      resources :flickr_photos,          :path => 'flickr-photos'
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

    root :to => 'dashboard#index', :as => :dashboard
    get 'report', :to => 'dashboard#report', :as => :system_report
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
    member do
      get    :join
      delete :leave
    end
  end

  resources :subscribers

  get 'contact-us',  :to => 'contacts#new', :as => :contact_us
  post 'contact-us', :to => 'contacts#create'

  %w(about privacy_policy terms_and_conditions sitemap).each do |page|
    get page.dasherize, :to => "pages##{page}", :as => page.to_sym
  end

  root :to => "pages#index"

  get 'errors/not-found',             :to => 'errors#not_found'
  get 'errors/internal-server-error', :to => 'errors#general_exception'
end
