Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :todos

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "/webauthn/register", to: "webauthn/registrations#challenge"
  get "/webauthn/register/verify", to: "webauthn/registrations#verify"
  get "/webauthn/session", to: "webauthn/authentication#challenge"
  get "/webauthn/session/verify", to: "webauthn/authentication#verify"

  root "todos#index"
end
