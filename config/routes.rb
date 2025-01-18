Rails.application.routes.draw do
  root "main#index"

  resources :items, only: [:index] do
    collection { post :import }
  end
  resources :cities, only: [:index] do
    collection { post :import }
  end

  # ヘルスチェック用
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
