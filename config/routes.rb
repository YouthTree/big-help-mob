Bighelpmob::Application.routes.draw do |map|
  resources :user_session, :as => 'user-sessions'
  
  get   'sign-in', :to => 'user_sessions#new', :as => :sign_in
  post  'sign-in', :to => 'user_sessions#create'
  match 'sign-out', :to => 'user_sessions#destroy', :as => :sign_out
  
  resources :users do
    member do
      post :add_rxp_auth
    end
  end
  
  namespace :admin do
    resources :users
    resources :missions
    resources :organisations
    resources :pickups
    resources :contents
    resources :questions do
      collection do
        post :reorder
      end
    end
    match '', :to => 'admin/dashboard#index', :as => :dashboard
  end
  
  # Mission Routes.
  # match 'missions/next',      :to => 'missions#next',  :as => :next_mission
  # match 'missions/:id',       :to => 'missions#show',  :as => :mission
  # match 'missions/:id/join',  :to => 'missions#join',  :as => :join_mission
  # match 'missions/:id/edit-details', :to => 'missions#edit', :as => :edit_mission
  
  get 'missions/:id/edit/:as', :to => 'missions#edit', :as => :edit_mission_with_role
  

  resources :missions do
    collection do
      get :next
    end
    member do
      get :join
    end
  end

  root :to => "pages#show"
end
