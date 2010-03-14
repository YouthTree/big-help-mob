Bighelpmob::Application.routes.draw do |map|

  match 'signin',  :to => 'user_sessions#new', :as => :signin
  match 'signout', :to => 'user_sessions#destroy', :as => :signout
  resources :user_session

  match 'signup', :to => 'users#new', :as => :signup
  resources :users do
    member do
      post :add_rxp_auth
    end
  end
  
  namespace :admin do
    resources :users
  end

  root :to => "pages#show"
end
