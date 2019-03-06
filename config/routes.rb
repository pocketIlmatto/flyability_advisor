Rails.application.routes.draw do
  root to: 'home#index'
  resources :fly_sites, only: [:index]
end
