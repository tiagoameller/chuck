Rails.application.routes.draw do
  resources :questions, only: [:index, :show, :create] do
    post :send_email, on: :member
    resources :answers, only: [:index]
  end

  get 'set_language/spanish'
  get 'set_language/english'

  root to: 'questions#index'
end
