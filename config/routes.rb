Rails.application.routes.draw do
  root 'orders#index'

  resources :orders do
    collection { post :import }    
  end

  resources :imports, only: [:new, :create]
end
