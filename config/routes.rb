Rails.application.routes.draw do

  put '/ept', to: 'users#ept'
  put '/users/unregister', to: 'users#unregister'

  resources :users do
    member do
      get :qr
    end
  end

  resources :notifications do
    member do
      post :deliver
    end

    collection do
      get :list
    end
  end

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/sessions/index', to: 'sessions#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#show'
end
