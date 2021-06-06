Rails.application.routes.draw do
  resources :questions, only: [:index, :show, :create] do
    post :send_email, on: :member
    resources :answers, only: [:index]
  end

  root to: 'questions#index'
end
