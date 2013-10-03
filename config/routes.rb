Splitsdb::Application.routes.draw do 
  get '/login'  => 'users#new'
  get '/signup' => 'users#new'
  get '/logout' => 'user_sessions#destroy'
  get '/upload' => 'runs#new'
  get '/games'  => 'games#index'

  get '/users/:id' => 'users#show', :as => :user
  get '/users/:id/edit' => 'users#edit', :as => :edit_user
  get '/:game_id/:category_id/runs/:id/compare/:compare_id' => 'runs#show', :as => :compare
  get '/:game_id/:category_id/runs/:id/download' => 'runs#download_exact'
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
end
