Copacetic::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root :to => 'application#frontpage'
  mount Ckeditor::Engine => '/ckeditor'



  namespace :admin do
    resources :comics do
      get :autocomplete_creator_firstname, :on => :collection
    end
    resources :dvds do
      get :autocomplete_director_firstname, :on => :collection
    end
    resources :books do
      get :autocomplete_creator_firstname, :on => :collection
    end
  end
  

 

  resources :authentications
  get '/auth/:provider/callback' => 'authentications#create'
  get '/:controller/:id/others/:offset', :controller => :controller, :action => :others, :id => :id, :offset => :offset
  resources :searches
  get '/just_in' => 'justins#latest'
  get '/just_in/:id' => 'justins#show'

  get '/logout' => 'sessions#destroy', :as => :logout
  get '/login' => 'sessions#new', :as => :login
  get '/register' => 'users#create', :as => :register
  get '/artists/:id' => 'cds#by_artist'
  get '/signup' => 'users#new', :as => :signup
  get '/copacetica' => 'articles#index'
  resources :users
  # match '/activate/:activation_code' => 'users#activate', :as => :activate, :activation_code => 
  resources :comics do
    get :autocomplete_creator_firstname, :on => :collection
  end

  resources :books do
    get :autocomplete_creator_firstname, :on => :collection
  end
  resources :dvds do
    get :autocomplete_director_firstname, :on => :collection
  end
  
  resources :cds do
    get :autocomplete_cd_artist, :on => :collection
  end
  resources :creators
  resources :labels
  resources :directors
  resources :publishers
  resource :session
  resources :serials
  resources :specials
  resources :articles
  # match '/logout' => 'sessions#destroy', :as => :logout
  # match '/login' => 'sessions#new', :as => :login
  # match '/register' => 'users#create', :as => :register
  # match '/signup' => 'users#new', :as => :signup
  resources :users
  resource :session
  resources :posts

  # match '/:controller(/:action(/:id))'
end
