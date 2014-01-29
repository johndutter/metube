Metube::Application.routes.draw do
  get "layout/index"

  get "partial/:partial", to: "partial#show"
  get "secured/:partial", to: "partial#show_secured"
  
  # for angular page prefetch
  get "loggedin", to: "session#loggedin"

  # API Routes
  match "api/login", to: "session#login", via: [:post]
  match "api/logout", to: "session#logout", via: [:get]
  match "api/signup", to: "users#create", via: [:post]
  match "api/logout", to: "session#logout", via: [:post]
  match "api/get-user-info", to: "users#get_user_info", via: [:get]

  root to: "layout#index"
  resources :users

  # if nothing else caught route--redirect
  # this must stay at the bottom of all the routes
  match '*path', to: 'layout#index', via: [:get]
end
