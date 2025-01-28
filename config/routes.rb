Rails.application.routes.draw do
  root "prices#index"

  resources :items, only: [ :index ] do
    collection { post :import }
  end

  resources :cities, only: [ :index ] do
    collection do
      post :import
    end
  end

  resources :prices, only: [] do
    collection do
      get :select_city
      get :edit_by_city
      post :edit_by_city
      post :add_price_field
    end
  end

  # resources :prices, only: [] do
  #   collection do
  #     get :select_city # 都市選択画面
  #     get :edit_by_city # 選択した都市の編集画面
  #   end
  #   patch :update_multiple, on: :collection # 一括更新用
  # end

  # ヘルスチェック用
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
