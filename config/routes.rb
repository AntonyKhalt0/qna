Rails.application.routes.draw do
  devise_for :users
  
  root to: 'questions#index'
  
  resources :questions do
    resources :answers, shallow: true, only: [:create, :update, :destroy]

    patch :update_best_answer, on: :member
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
end
