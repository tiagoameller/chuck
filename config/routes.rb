Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  devise_scope :user do
    namespace :admin do
      resources :users do
        patch :set_company, on: :member
        patch :set_active, on: :member
      end
      resources :companies, except: [:new, :create]
    end

    resources :audits, only: [] do
      get :last, on: :collection
    end
    root to: 'welcome#index', as: :authenticated_root
  end

  namespace :public do
    resources :prospects, only: [:new, :create] do
      get 'unsubscribe', on: :collection
    end
    resources :signup, only: [:index, :new, :create]
    resources :health_checks, only: [:index]
  end

  # avoid authentication for pages controller: https://blog.lodr.io/rails-static-pages-with-high-voltage-446fa49e955
  get '/pages/*id' => 'pages#show', as: :page, format: false

  # root 'public#index'
  root 'devise/sessions#new'
end
