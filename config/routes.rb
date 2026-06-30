Rails.application.routes.draw do
  root "dashboard#index"

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "up" => "rails/health#show", as: :rails_health_check

  resources :users, only: [:index, :show, :create, :update, :destroy]
  resources :seasons, only: [:create]
end
