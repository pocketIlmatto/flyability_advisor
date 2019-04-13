Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :fly_sites, only: [:create, :edit, :get_fly_sites, :new, :show, :update]
end
