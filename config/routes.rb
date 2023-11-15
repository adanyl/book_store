Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  
  resources :books, only: [:index, :show]
  resources :reviews, except: [:index]
  resources :order_items, only: [:destroy]
  resources :orders, only: [:index, :show, :update]

  post 'checkout/create_order_item', to: 'checkout#create_order_item', as: 'create_order_item'
  get 'checkout/show_draft_order', to: 'checkout#show_draft_order', as: 'show_draft_order'
end
