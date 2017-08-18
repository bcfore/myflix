Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'

  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  get '/force_signout', to: 'sessions#force_signout'

  get '/home', to: 'videos#index'

  get '/my_queue', to: 'queued_user_videos#index'
  # put '/my_queue', to: 'queued_user_videos#update'
  post 'update_queue', to: 'queued_user_videos#update_queue'

  resources :users, only: [:create]
  resources :categories, only: [:show]

  resources :videos, only: [:show] do
    collection do
      get :search, to: 'videos#search'
    end

    member do
      post '/my_queue', to: 'queued_user_videos#create'
      delete '/my_queue', to: 'queued_user_videos#destroy'
    end

    resources :reviews, only: [:create]
  end
end
