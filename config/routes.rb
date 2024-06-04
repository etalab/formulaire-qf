Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up", to: "rails/health#show", as: :rails_health_check

  # get 'auth/:provider/callback', to: 'sessions#create'
  get "/callback", to: "sessions#create"
  get "/login", to: "sessions#new"

  get "collecte/:recipient/démarrer", to: "claims#index", as: :claims
  root "home#index"
end
