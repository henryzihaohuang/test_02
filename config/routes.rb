require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'

  root 'searches#show'

  resource :user_session, only: [:new, :create, :destroy]
  resource :search, only: [:show]
  resource :company, only: [] do
    collection do
      get :dashboard
    end
  end

  resources :candidates, only: [:show]
  resources :pipelines, only: [:index, :show, :destroy] do
    member do
      get :download
    end
  end

  get '/sign_in', to: 'user_sessions#new', as: :sign_in
  delete '/logout', to: 'user_sessions#destroy', as: :logout

  namespace :api do
    resources :candidates, only: [] do
      member do
        post :save
        post :delete
        post :contact
      end
    end
    resources :pipelines, only: [:index, :create]
    resources :saved_candidates, only: [:update]
    resources :app_sessions, only: [:create]
  end

  namespace :admin do
    resources :companies, only: [:index, :show]

    root "companies#index"
  end

  post '/webhooks/sync_user', to: 'webhooks#sync_user', as: :sync_user_webhook
  post "/webhooks/sync_companies", to: "webhooks#sync_companies", as: :sync_companies_webhook
end
