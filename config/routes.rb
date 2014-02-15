Myflix::Application.routes.draw do
  root to: 'pages#front'
  get '/home', to: 'videos#index'
  
  resources :videos, only: [:show] do
    collection do
      post 'search', to: "videos#search"
    end
     resources :reviews, only: [:create]
  end
  
  get 'my_queue', to: 'queue_items#index'
 
  get 'ui(/:action)', controller: 'ui'
  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  get '/sign_out', to: 'sessions#destroy'

  resources :users
  resources :categories, only: [:show]
  resource  :queue_items, only: [:create, :destroy]
  resources :sessions, only: [:create]  
end