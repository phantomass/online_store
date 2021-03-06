OnlineStore::Application.routes.draw do
  resources :categories

  get 'admin' => 'admin#index'
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end
  # get "admin/index"
  # get "sessions/new"
  # get "sessions/create"
  # get "sessions/destroy"
  resources :users

  resources :orders

  resources :line_items

  resources :carts
  root 'store#index'
  #match '/404' => redirect('/'), via: :all
  #match '/422' => redirect('/'), via: :all
  #match '/500' => redirect('/'), via: :all
  get 'products/table', to: 'products#table'
  match '/about',   to: 'store#about',   via: 'get'
  match '/services',   to: 'store#services',   via: 'get'
  match '/contacts',   to: 'store#contacts',   via: 'get'
  resources :products do
    get :who_bought, on: :member
  end
  resources :line_items do
    put 'decrease', on: :member
    put 'increase', on: :member
  end



  match '*path' => redirect('/'), via: :get

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
