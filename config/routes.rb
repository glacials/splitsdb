Splitsdb::Application.routes.draw do 
  resources :authentications

  get '/login'  => 'users#new'
  get '/login/twitch'      => 'user_sessions#twitch_login'
  get '/login/twitch/auth' => 'user_sessions#twitch_auth'

  get '/signup' => 'users#new'
  get '/logout' => 'user_sessions#destroy'
  get '/upload' => 'runs#new'
  get '/games'  => 'games#index'
  post '/games' => 'games#create'

  get '/users/:id' => 'users#show', :as => :user
  get '/users/:id/edit' => 'users#edit', :as => :edit_user
  get '/:id/delete' => 'games#destroy'
  get '/:game_id/:category_id/runs/:id/compare/:compare_id' => 'runs#show', :as => :compare
  get '/:game_id/:category_id/runs/:id/download' => 'runs#download_exact'
  get '/:game_id/:category_id/runs/:id/delete' => 'runs#destroy'
  #get '/:game_id/:category_id/runs/:id/download-route' => 'runs#download_blank'

  root 'static_pages#home'

  resources :users do
    resources :runs
  end
  resources :games, :path => ''
  resources :games, :path => '', :only => [] do
    resources :categories, :path => '' do
      resources :runs
    end
    #get :autocomplete_game_name, :on => :collection
  end

  post '/:game_id/:category_id/runs/:id' => 'runs#compare'
#  match '/auth/:provider/callback' => 'authentications#create'
end
