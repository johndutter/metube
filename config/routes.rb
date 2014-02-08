Metube::Application.routes.draw do
  get "layout/index"

  get "partial/:partial", to: "partial#show"
  get "secured/:partial", to: "partial#show_secured"

  # API Routes
  match "api/login", to: "session#login", via: [:post]
  match "api/logout", to: "session#logout", via: [:get]
  match "api/signup", to: "users#create", via: [:post]
  match "api/logout", to: "session#logout", via: [:post]
  match "api/get-user-info", to: "users#get_user_info", via: [:get]
  match "api/get-user-profile", to: "users#get_user_profile", via: [:get]
  match "api/update-user-profile", to: "users#update_user_profile", via: [:post]
  match "api/update-user-password", to: "users#update_user_password", via: [:post]

  # for angular page prefetch
  match "api/loggedin", to: "session#loggedin", via: [:get]

  root to: "layout#index"
  resources :users

  # if nothing else caught route--redirect
  # this must stay at the bottom of all the routes
  match '*path', to: 'layout#index', via: [:get]
end
