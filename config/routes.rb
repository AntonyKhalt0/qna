# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  concern :votable do
    member do
      patch :upvote
      patch :downvote
      delete :unvote
    end
  end

  concern :commentable do
    member do
      post :create_comment
    end
  end

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      concerns :votable
      concerns :commentable
    end

    concerns :votable
    concerns :commentable

    patch :update_best_answer, on: :member
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index
  resources :accounts, only: :create

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[show create update destroy], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
