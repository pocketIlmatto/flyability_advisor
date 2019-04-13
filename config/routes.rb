Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, path_names: {
    sign_up: '/404.html',
    sign_in: '/404.html'
  }
  resources :fly_sites, only: [:create, :edit, :get_fly_sites, :new, :show, :update] do
    member do
      post :favorite
    end
  end
  get '*path' => redirect('/404.html')
end
