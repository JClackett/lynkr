Rails.application.routes.draw do

  # ----------------------------------------------------------
    # Links
  # ----------------------------------------------------------

  resources :links , except: [:edit, :show ] do
    member do
      get 'favourite'
      get 'update_description'
    end
  end
  get 'favourites' => 'links#favourites'
  
  # ----------------------------------------------------------
    # Collections
  # ----------------------------------------------------------

  resources :collections, except: [:edit, :show ] do
    member do
      get 'pin'
      delete 'unfollow'
    end
  end

  get "browse/:collection_id" => "collections#browse", :as => "browse"
  get "browse/:collection_id/new_collection" => "collections#new", :as => "new_sub_collection"
  get "browse/:collection_id/new_link" => "links#new", :as => "new_sub_link"

  post "collection/share" => "collections#share"

  # ----------------------------------------------------------
    # Devise
  # ----------------------------------------------------------

  devise_for :users
  devise_scope :user do 
      get 'register', to: "devise/registrations#new"
      get 'login', to: "devise/sessions#new"
  end

  # ----------------------------------------------------------
    # Where users go upon opening site
  # ----------------------------------------------------------

  authenticated :user do
    get '/', to: "collections#index"
  end
  unauthenticated :user do
    root to: 'static_pages#home' 
  end

  # ----------------------------------------------------------
    # Static Pages
  # ----------------------------------------------------------
  get 'home' => 'static_pages#home', as: :home


end
