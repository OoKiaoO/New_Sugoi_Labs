Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :items do
    resources :item_amounts, only: %i[new create edit update]

    collection do
      get :expiring_soon
      get :expired
    end
  end
  resources :item_amounts, only: [:destroy]
  resources :users, only: [:show, :edit, :update]
  root to: 'items#home'
end
