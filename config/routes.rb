Bookies::Application.routes.draw do
  # root of site, set to bookmarks index page
  root :to => 'bookmarks#index'

  # resources creates CRUD routes for these models
  resources :users, :bookmarks, :tags

  # get "tag/:id" => "tag#show"

  # # 1. returns a form with a single textfield labeled "new name" 
  # get "tag/:id/rename" => "tag#rename"

  # # 2. rename tag with id to name 
  # get "tag/:id/rename/:name" => "tag#update"

  # get "tag/:id/delete" => "tag#delete"

  # get "tag/:name/search" => "tag#search"

  # get "user/login" => "user#login"

  # # return an html form for a new user
  # get "user/register" => "user#new"

  # post "users" => "user#create"

  # get "user/:id/delete" => "user#destroy"

  # get "user/:id/edit" => "user#edit"

  # get "user/:id" => "user#show"

  # get "user/:name/search" => "user#search"

  # get "user/:id/change_password" => "user#update"

  # # TODO set up action emailer for password reset
  # get "user/reset_password" => "user#update"
  


  # # return html form for new bookmark
  # get "bookmark/new" => "bookmark#new"

  # post "bookmark" => "bookmark#create"

  # get "bookmark/:id" => "bookmark#show"

  # get "bookmark/:id/edit" => "bookmark#new"

  # get "bookmark/:id/delete" => "bookmark#destroy"

  # get "bookmark/:name/search" => "bookmark#search"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
