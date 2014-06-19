Bookies::Application.routes.draw do
  # root of site, set to bookmarks index page
  root :to => 'bookmarks#index'

  # resources creates CRUD routes for these models
  resources :users, :bookmarks, :tags, :sessions, :identities

  # for omniauth
  post 'auth/:provider/callback', to: 'sessions#create'
  # had to hardcode identity route in rails 4
  post 'auth/identity/callback', to: 'sessions#create'
  # auth/../callback is post only 
  get 'auth/:provider/callback', to: 'sessions#create'
  # match 'auth/failure', to: redirect('/')
  match 'auth/failure' => 'sessions#new', :notice => "Email or password incorrect", via: :get
  match 'signout', to: 'sessions#destroy', as: 'signout', via: :get

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "register" => "users#new", :as => "register"
  get "signup" => "users#new", :as => "signup"

  get "my_bookmarks" => "bookmarks#user_bookmarks", :as => "my_bookmarks"

  get "tag/:id" => "tag#show"

  match "search" => "search#index", via: :get

  # show stream of bookmarks for specific tag
  get "tags/:id/bookmarks" => "tags#bookmarks"
  get "tags/name/:name" => "tags#name"
  get "tags/user/:id" => "tags#user"

  get "bookmarks/user/:id" => "bookmarks#user"
  get "user/:id/bookmarks" => "bookmarks#user"
  get "bookmarklet" => "bookmarks#bookmarklet"
  get "bookmarklet/success" => "bookmarks#success"

  # for delicious API v1
  get "api/posts/all" => "api#posts_all"
  get "api/posts/all/:tag" => "api#posts_all"
  get "api/posts/:id" => "api#index"

end
