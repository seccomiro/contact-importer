Rails.application.routes.draw do
  resources :contacts, only: [:index]
  devise_for :users
  root to: 'home#index'
end
