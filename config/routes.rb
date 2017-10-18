Rails.application.routes.draw do
  resources :notifications do
    member do
      post :deliver
    end

    collection do
      get :list
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
end
