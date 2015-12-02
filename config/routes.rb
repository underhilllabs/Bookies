Bookies::Application.routes.draw do
  # root of site, set to bookmarks index page
  root :to => 'bookmarks#index'

  # resources creates CRUD routes for these models
  resources :users, :bookmarks, :sessions, :identities

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
  get "user/regenerate_token" => "users#regenerate_token"

  get "my_bookmarks" => "bookmarks#user_bookmarks", :as => "my_bookmarks"

  get "search" => "search#index"

  get "tags/" => "tags#index", :as => "tags"
  # show stream of bookmarks for specific tag
  get "tags/name/:name" => "bookmarks#tag", :as => "tags_name"
  # show Most popular tags of user
  get "tags/user/:id" => "tags#user", :as => "tags_user"

  get "bookmarks/:id/delete" => 'bookmarks#destroy', :as => "delete_bookmark"
  get "bookmarks/user/:id" => "bookmarks#user"
  # show archive of URL if it exists
  get "bookmarks/archive/:id" => "bookmarks#archive", :as => "archive_bookmark"
  get "user/:id/bookmarks" => "bookmarks#user"
  get "bookmarklet" => "bookmarks#bookmarklet"
  get "bookmarklet/success" => "bookmarks#success"

  # for delicious API v1
  get "api/posts/all" => "api#posts_all"
  get "api/posts/all/:tag" => "api#posts_all"
  get "api/posts/:id" => "api#index"
  get "api/upload"   => "api#upload"
  post "api/import"   => "api#import"
  post "api/posts/add"   => "api#posts_add"

  mount Resque::Server, :at => "/resque-web"
end
