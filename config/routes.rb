Rails.application.routes.draw do
  root 'store#index', as: 'store_index'
  resources :orders
  resources :products do
    get :who_bought, on: :member
  end
  resources :line_items
  delete "line_items/decrement/:id" => "line_items#decrement"
  resources :carts
end
