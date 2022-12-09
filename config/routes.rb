Rails.application.routes.draw do
  root 'store#index', as: 'store_index'
  resources :products
  resources :line_items
  resources :carts
end
