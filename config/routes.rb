Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up", to: "rails/health#show", as: :rails_health_check

  # I don't exactly understand why omniauth calls this local route instead of the
  # FranceConnect one in features, there might be a better configuration to do :shrug:
  get "/api/v1/logout", to: "home#index" if Rails.env.test?

  get "/callback", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout
  get "/logout-callback", to: "sessions#fc_callback", as: :fc_logout_callback

  resources :collectivities, only: %i[index show] do
    collection do
      get :select
    end

    resources :shipments, only: %i[new show create]
  end

  get "faq", to: "home#faq"

  root "home#index"

  mount GoodJob::Engine => "good_job"
end
