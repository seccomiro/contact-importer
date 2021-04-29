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
end
