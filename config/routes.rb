Rails.application.routes.draw do
  root 'store#index', as: 'store_index'
  resources :orders
  resources :products do
    get :who_bought, on: :member
  end
  resources :line_items do
    delete :decrement, on: :member
  end
  resources :carts
end
