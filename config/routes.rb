Rails.application.routes.draw do
  resources :questions, only: [:index, :show, :create]

  root to: 'questions#index'
end
