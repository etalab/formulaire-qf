Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up", to: "rails/health#show", as: :rails_health_check

  # get 'auth/:provider/callback', to: 'sessions#create'
  get "/callback", to: "sessions#create"
  get "/login", to: "sessions#new"

  resources :collectivities, only: :index

  # TODO review the controller/route separations
  get "collecte/(:recipient)/commencer", to: "claims#index", as: :claims
  get "collecte/:recipient/quotient-familial", to: "claims#quotient_familial", as: :quotient_familial_claims
  get "collecte/:recipient/transmettre", to: "claims#send_qf", as: :send_qf
  root "home#index"
end
