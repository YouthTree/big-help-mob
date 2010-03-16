Bighelpmob::Application.routes.draw do |map|

  match 'sign-in',  :to => 'user_sessions#new', :as => :signin
  match 'sign-out', :to => 'user_sessions#destroy', :as => :signout
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
  end

  root :to => "pages#show"
end
