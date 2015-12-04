Rails.application.routes.draw do

  resources :links , except: [:edit ] do
    member do
      get 'favourite'
      get 'update_description'
    end
  end

  get "browse/:collection_id" => "collections#browse", :as => "browse"
  get "browse/:collection_id/new_collection" => "collections#new", :as => "new_sub_collection"
  get "browse/:collection_id/new_link" => "links#new", :as => "new_sub_link"
  post "collection/share" => "collections#share"

  get 'favourites' => 'links#favourites'

  resources :collections

  devise_for :users
  devise_scope :user do 
      get 'register', to: "devise/registrations#new"
  end



  authenticated :user do
    root :to => "collections#index"
  end
  unauthenticated :user do
    devise_scope :user do 
      get '/', to: "devise/sessions#new"
    end
  end

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
