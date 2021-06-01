Rails.application.routes.draw do
  resources :contacts, only: [:index]
  resources :imports, only: [:index, :show, :new, :create] do
    member do
      post :assign
      get :execute
    end
  end
  devise_for :users
  root to: 'home#index'

  namespace :api do
    namespace :v1 do
      resources :contacts, only: [:index]
    end
  end
end
