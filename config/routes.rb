Rails.application.routes.draw do
  devise_for :users, skip: :all
  root to: "home#index"

  # health
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA
  get "manifest.json" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker.js" => "rails/pwa#service_worker", as: :pwa_service_worker

  resources :communities, only: %i[index show new create] do
    resources :posts, only: %i[new create]
  end

  namespace :api do
    namespace :v1 do
      post "auth/sign_up", to: "auth#sign_up"
      post "auth/sign_in", to: "auth#sign_in"
      delete "auth/sign_out", to: "auth#sign_out"
      post "auth/request_otp", to: "auth#request_otp"
      post "auth/verify_otp", to: "auth#verify_otp"

      resources :communities, only: %i[index show create] do
        resources :memberships, only: %i[create destroy], param: :user_id
      end
      resources :users, only: %i[show]
      resources :posts do
        resources :comments, only: %i[index]
      end
      resources :comments, only: %i[create update destroy]
      resources :posts, only: %i[index show create update destroy]
      resources :votes, only: %i[create]
      get "search", to: "search#index"
      get "rag/export", to: "rag#export"
      get "notifications", to: "notifications#index"
      post "notifications/:id/read", to: "notifications#mark_read"
      post "moderation/posts/:post_id/remove", to: "moderation#remove_post"
      post "moderation/posts/:post_id/pin", to: "moderation#pin_post"
      post "moderation/comments/:comment_id/remove", to: "moderation#remove_comment"
    end
  end
end
