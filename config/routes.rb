Rails.application.routes.draw do
  resources :fly_sites, only: [:index]
end
