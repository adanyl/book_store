Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  
  resources :books, only: [:index, :show]
  resources :reviews, except: [:index]
end
