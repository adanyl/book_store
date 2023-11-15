Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  
  resources :books, only: [:index, :show]
  resources :reviews, except: [:index]

  post 'checkout/create_order_item', to: 'checkout#create_order_item', as: 'create_order_item'
end
