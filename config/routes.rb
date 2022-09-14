Rails.application.routes.draw do
  devise_for :users
  
  root to: 'questions#index'

  concern :votable do
    member do
      patch :upvote
      patch :downvote
      delete :unvote
    end
  end

  concern :commentable do
    post :comment_create
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

  mount ActionCable.server => '/cable'
end
