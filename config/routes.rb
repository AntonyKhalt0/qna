Rails.application.routes.draw do
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
    resources :answers, shallow: true, only: [:create, :update, :destroy] do
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

      resources :questions, only: [:index, :show, :create, :update, :destroy]
    end
  end

  mount ActionCable.server => '/cable'
end
