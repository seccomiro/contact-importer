Rails.application.routes.draw do
  resources :contacts, only: [:index]
  resources :imports, only: [:index, :show, :new, :create] do
    get :assign
    post :process
  end
  devise_for :users
  root to: 'home#index'
end
