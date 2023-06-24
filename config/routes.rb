require 'sidekiq/web'

Rails.application.routes.draw do
  unauthenticated do
    root to: 'home#index'
  end

  authenticate :user do
    root to: 'exercises#index', as: :authenticated_root
  end

  resources :exercises do
    resources :iterations do
      collection do
        post :run
      end
    end
  end

  resources :containers do
    collection do
      post :destroy_all
    end

    member do
      post :stop
      post :start
    end
  end

  # Things from the Jumpstart Rails template which I don't need right now
  # authenticate :user, lambda { |u| u.admin? } do
  #   mount Sidekiq::Web => '/sidekiq'

  #   namespace :madmin do
  #     resources :impersonates do
  #       post :impersonate, on: :member
  #       post :stop_impersonating, on: :collection
  #     end
  #   end
  # end

  # resources :notifications, only: [:index]
  # resources :announcements, only: [:index]
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
end
