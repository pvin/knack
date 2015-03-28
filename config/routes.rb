Knack::Application.routes.draw do

  #match "direction/redirect"

  match "direction/demo"

  devise_for :users
  #root :to => 'sof#consumer'
  root :to => 'app#app_home'

  match 'direction/redirect'
  match 'coder/getoption'
  match 'grammarian/getoption'
  match 'grammarian/elu_consumer'
  match 'mathematician/getoption'
  match 'mathematician/maths_consumer'
  match 'admins/getoption'
  match 'admins/server_fault_consumer'
  match 'admins/getoption'
  match 'admins/super_user_consumer'
  match 'admins/getoption'
  match 'admins/ask_ubuntu_consumer'
  match 'coder/sof_consumer'
  match 'coder/git_consumer'
  match 'coder/blog_consumer'
  match 'coder/bit_b_consumer'
  match 'coder/linked_in_consumer'
  match 'coder/programmers_consumer'

  #contact form routing
  match 'message' => 'message#new', :as => 'message', :via => :get
  match 'message' => 'message#create', :as => 'message', :via => :post


  match "*path" => redirect("/")
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
  # just remember to delete public/consumer.html.
  # root :to => 'welcome#consumer'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
