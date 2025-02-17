Rails.application.routes.draw do
  root "prices#index"

  resources :items, only: [ :index, :destroy ] do
    collection { post :import }
  end

  resources :cities, only: [ :index, :destroy ] do
    collection { post :import }
  end

  resources :prices, only: [ :index, :new, :create ] do
    resources :interests, only: [ :create ]
    collection do
      get :search
      get :select_city
      get :edit_by_city
      post :edit_by_city
      post :add_price_field
      get :confirm
      post :confirm
      get :update_by_city
      patch :update_by_city
    end
  end

  # 認証用のルート
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"

  get "tutorial", to: "static_pages#tutorial"
  get "privacy_policy", to: "static_pages#privacy_policy"
  get "terms_of_service", to: "static_pages#terms_of_service"
  get "contact", to: "static_pages#contact"

  # 動的なPWAを使うためのルーティング from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
