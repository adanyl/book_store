Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  
  get '/books' => 'books#index', as: 'books'
end
