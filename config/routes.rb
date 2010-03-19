Bighelpmob::Application.routes.draw do |map|
  resources :user_session, :as => 'user-sessions'

  match 'sign-up', :to => 'users#new', :as => :signup
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
