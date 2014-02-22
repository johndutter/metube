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

  match "api/upload", to: "multimedia#create", via: [:post]
  match "api/upload-file", to: "multimedia#save_file", via: [:post]
  match "api/transcode-video", to: "multimedia#transcode_to_mp4", via: [:post]
  match "api/get-user-multimedia", to: "multimedia#get_user_multimedia", via: [:get]

  match "api/get-user-profile", to: "users#get_user_profile", via: [:get]
  match "api/update-user-profile", to: "users#update_user_profile", via: [:post]
  match "api/update-user-password", to: "users#update_user_password", via: [:post]
  match "api/get-uploader-info", to: "users#get_uploader_info", via: [:get]
  
  match "api/get-sentiment-info", to: "users#get_sentiment_info", via: [:get]
  match "api/sentiment-multimedia", to: "users#sentiment_multimedia", via: [:post]
  match "api/get-user-multimedia-in-progress", to: "users#get_user_multimedia_in_progress", via: [:get]

  match "api/get-multimedia-info", to: "multimedia#get_multimedia_info", via: [:get]
  match "api/get-multimedia-progress", to: "multimedia#get_multimedia_progress", via: [:get]
  match "api/update-view-count", to: "multimedia#update_view_count", via: [:post]

  match "api/download", to: "multimedia#download", via: [:get]

  # for angular page prefetch
  match "api/loggedin", to: "session#loggedin", via: [:get]

  root to: "layout#index"
  resources :users

  # if nothing else caught route--redirect
  # this must stay at the bottom of all the routes
  match '*path', to: 'layout#index', via: [:get]
end
