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

  resources :collectivities, only: %i[index], path: "collectivites" do
    member do
      get :show, path: "me_connecter"
    end

    collection do
      get :select
    end

    get "/envoyer_mes_donnees", to: "shipments#new", as: :new_shipment

    resources :shipments, only: %i[show create], param: :reference do
    end
  end

  get "/cgu_usagers", to: "home#cgu_usagers"
  get "/cgu_administrations", to: "home#cgu_administrations"
  get "/accessibilite", to: "home#accessibilite"
  get "faq", to: "home#faq"

  root "home#index"

  mount GoodJob::Engine => "good_job"
end
