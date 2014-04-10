Metube::Application.routes.draw do
  get "layout/index"

  get "partial/:partial", to: "partial#show"
  get "secured/:partial", to: "partial#show_secured"

  # API Routes

  # ===========================
  # Session Routes
  # ===========================
  match "api/login", to: "session#login", via: [:post]
  match "api/logout", to: "session#logout", via: [:get]
  match "api/signup", to: "users#create", via: [:post]
  match "api/logout", to: "session#logout", via: [:post]
  # for angular page prefetch
  match "api/loggedin", to: "session#loggedin", via: [:get]

  # ===========================
  # Multimedia Routes
  # ===========================
  match "api/upload", to: "multimedia#create", via: [:post]
  match "api/upload-file", to: "multimedia#save_file", via: [:post]
  match "api/transcode-video", to: "multimedia#transcode_to_mp4", via: [:post]
  match "api/get-user-multimedia", to: "multimedia#get_user_multimedia", via: [:get]

  match "api/get-multimedia-info", to: "multimedia#get_multimedia_info", via: [:get]
  match "api/get-multimedia-progress", to: "multimedia#get_multimedia_progress", via: [:get]
  match "api/update-view-count", to: "multimedia#update_view_count", via: [:post]
  match "api/get-playlist-multimedia", to: "multimedia#get_playlist_multimedia", via: [:get]
  match "api/download", to: "multimedia#download", via: [:get]

  match "api/get-multimedia", to: "multimedia#get_multimedia", via: [:get]

  # ===========================
  # User Routes
  # ===========================
  match "api/get-user-profile", to: "users#get_user_profile", via: [:get]
  match "api/update-user-profile", to: "users#update_user_profile", via: [:post]
  match "api/update-user-password", to: "users#update_user_password", via: [:post]
  match "api/get-uploader-info", to: "users#get_uploader_info", via: [:get]
  match "api/update-playlist-sentiment", to: "users#update_playlist_sentiment", via: [:post]
  
  match "api/get-user-info", to: "users#get_user_info", via: [:get]
  match "api/get-sentiment-info", to: "users#get_sentiment_info", via: [:get]
  match "api/sentiment-multimedia", to: "users#sentiment_multimedia", via: [:post]
  match "api/get-playlist-sentiment", to: "users#get_playlist_sentiment", via: [:get]
  match "api/get-user-multimedia-in-progress", to: "users#get_user_multimedia_in_progress", via: [:get]

  # for angular page prefetch
  match "api/loggedin", to: "session#loggedin", via: [:get]

  # ===========================
  # Category Routes
  # ===========================  
  match "api/get-categories", to: "categories#get_categories", via: [:get]  

  # ===========================
  # Message Routes
  # ===========================  
  match "api/send-message", to: "messages#create_message", via: [:post]
  match "api/get-sent-messages", to: "messages#get_sent_messages", via: [:get]
  match "api/get-message", to: "messages#get_message", via: [:get]
  match "api/get-received-messages", to: "messages#get_received_messages", via: [:get]

  match "api/mark-as-read", to: "messages#mark_as_read", via: [:post]
  match "api/delete-as-sender", to: "messages#delete_as_sender", via: [:post]
  match "api/delete-as-recipient", to: "messages#delete_as_recipient", via: [:post]
  match "api/suggest-recipients", to: "messages#suggest_recipients", via: [:get]

  
  # ===========================
  # Subscription Routes
  # ===========================  
  match "api/subscribe", to: "subscriptions#create_subscription", via: [:post]
  match "api/get-user-subscriptions", to: "subscriptions#get_user_subscriptions", via: [:get]
  match "api/is-user-subscribed", to: "subscriptions#is_user_subscribed?", via: [:get]
  match "api/unsubscribe", to: "subscriptions#delete_subscription", via: [:post]
  match "api/get-user-subscriptions-overview", to: "subscriptions#get_user_subscriptions_overview", via: [:get]

  match "api/get-channels", to: "users#get_channels", via: [:get]
  match "api/get-few-channels", to: "users#get_few_channels", via: [:get]
  match "api/get-channel-stats", to: "subscriptions#get_channel_stats", via: [:get]
  match "api/update-channel-view-count", to: "subscriptions#update_view_count", via: [:post]


  # ===========================
  # Playlist Routes
  # ===========================
  match "api/create-playlist", to: "playlists#create_playlist", via: [:post]
  match "api/get-playlist-info", to: "playlists#get_playlist_info", via: [:get]
  match "api/get-user-playlists", to: "playlists#get_user_playlists", via: [:get]
  match "api/get-user-liked-playlists", to: "playlists#get_user_liked_playlists", via: [:get]
  match "api/update-playlist-view-count", to: "playlists#update_view_count", via: [:post]
  match "api/get-playlists", to: "playlists#get_playlists", via: [:get]
  match "api/get-few-playlists", to: "playlists#get_few_playlists", via: [:get]
  match "api/get-user-playlists-overview", to: "playlists#get_user_playlists_overview", via: [:get]

  match "api/get-playlist-thumbnails", to: "playlists#get_playlist_thumbnails", via: [:get]
  match "api/add-media-to-playlist", to: "playlists#add_media_to_playlist", via: [:post]
  match "api/remove-media-from-playlist", to: "playlists#remove_media_from_playlist", via: [:post]
  match "api/playlist-has-multimedia", to: "playlists#playlist_has_multimedia?", via: [:get]
  match "api/delete-playlist", to: "playlists#delete_playlist", via: [:post]

  root to: "layout#index"
  resources :users

  # if nothing else caught route--redirect
  # this must stay at the bottom of all the routes
  match '*path', to: 'layout#index', via: [:get]
end
