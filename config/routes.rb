Rails.application.routes.draw do
  root to: 'home#index'
  resources :fly_sites, only: [:create, :edit, :get_fly_sites, :new, :show, :update]
end
