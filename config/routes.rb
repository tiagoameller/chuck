Rails.application.routes.draw do
  resources :questions, only: [:index, :show, :create] do
    resources :answers, only: [:index]
  end

  root to: 'questions#index'
end
