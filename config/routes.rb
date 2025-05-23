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
  get "/auth/failure", to: "errors#auth_failure"

  resources :collectivities, only: %i[index], path: "collectivites" do
    member do
      get :show, path: "me_connecter"
      get :no_france_connect, path: "sans_france_connect"
    end

    collection do
      get :select
    end

    get "/erreur", to: "shipments#error", as: :shipment_error
    get "/envoyer_mes_donnees", to: "shipments#new", as: :new_shipment
    get "/confirmation/:reference", to: "shipments#show", as: :shipment

    resources :shipments, only: %i[create], param: :reference

    resources :cnaf_v1_family_quotients, only: %i[index create], path: "alternatives"
  end

  get "/cgu_usagers", to: "home#cgu_usagers"
  get "/cgu_administrations", to: "home#cgu_administrations"
  get "/accessibilite", to: "home#accessibilite"
  get "faq", to: "home#faq"
  get "/collectivites/:id", to: "collectivities#show", as: :simple_collectivity

  root "home#index"

  scope module: :api, path: "/api" do
    resources :collectivities, only: %i[index create show], path: "collectivites"

    resources :frontal, only: :index

    post "/datapass/webhook" => "datapass_webhooks#create"
  end

  mount GoodJob::Engine => "good_job"
end
