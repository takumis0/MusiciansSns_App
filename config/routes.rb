MusiciansSnsApp::Application.routes.draw do
  #get "users/show"
  get 'users/autocomplete_user/data' => 'users#autocomplete_user'
  get 'more_index' => 'users#more_index'
  patch 'edit_avatar_image' => 'users#edit_avatar_image'
  patch 'edit_header_image' => 'users#edit_header_image'
  patch 'edit_introduction' => 'users#edit_introduction'
  patch 'registration_twitter_id' => 'users#registration_twitter_id'
  patch 'destroy_twitter_id' => 'users#destroy_twitter_id'
  patch 'registration_line_id' => 'users#registration_line_id'
  patch 'destroy_line_id' => 'users#destroy_line_id'
  patch 'registration_facebook_id' => 'users#registration_facebook_id'
  patch 'destroy_facebook_id' => 'users#destroy_facebook_id'
  patch 'registration_adress_id' => 'users#registration_adress_id'
  patch 'destroy_adress_id' => 'users#destroy_adress_id'
  patch 'registration_instagram_id' => 'users#registration_instagram_id'
  patch 'destroy_instagram_id' => 'users#destroy_instagram_id'
  patch 'registration_youtube_url' => 'users#registration_youtube_url'
  patch 'destroy_youtube_url' => 'users#destroy_youtube_url'
  devise_for :users, :controllers => {
    :registrations => "registrations"
  }
  resources :users
  resources :favorites, only: [:create, :destroy]
  root  'static_pages#home'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
  match '/usage',   to: 'static_pages#usage',   via: 'get'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
