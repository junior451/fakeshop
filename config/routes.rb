Rails.application.routes.draw do  
  root 'store#index', as: 'store_index'
  get 'admin/home' => 'admin#home', as: 'admin'

  resources :orders

  resources :products do
    get :who_bought, on: :member
  end

  resources :line_items do
    delete :decrement, on: :member
  end

  resources :carts
  resources :users do
    get :edit_password, on: :member
    put :password_update, on: :member, as: "update_password"
  end

  controller :session do
    get "login" => :new
    post "login" => :create
    delete "logout" => :logout
  end
end
