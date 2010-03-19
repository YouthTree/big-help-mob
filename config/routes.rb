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

  root :to => "pages#show"
end
