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

  resources :questions do
    resources :answers, shallow: true, only: [:create, :update, :destroy] do
      concerns :votable
    end

    concerns :votable

    patch :update_best_answer, on: :member
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index
end
