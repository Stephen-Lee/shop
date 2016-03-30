# -*- encoding : utf-8 -*-
Rails.application.routes.draw do


  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks",registrations: "users/registrations"}
  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy'
  end

  root 'products#index'

  get '/search', to: 'products#search'
  get '/high_grade_search', to: 'products#high_grade_search'


  mount RuCaptcha::Engine => "/rucaptcha"

  namespace :admin do
    root 'home#dashboard'
    get '/root_manage', to: 'home#root_manage'

    resources :banners,only: [:create,:update,:destroy]

    resources :categories

    resources :products, except: [:show]

    resources :images, only: [:create] do
      delete 'del_image', on: :collection
    end

    resources :users, only: [:index, :edit, :update, :destroy] do
      post 'add', on: :collection
      delete 'remove', on: :member
    end

    resources :orders, only: [:index, :edit, :update, :destroy] do
      get "show_products", on: :member
    end

    resources :coupons, only: [:index,:create]

    resources :awards, only: [:index,:create,:edit,:update,:destroy]
  end

  resources :products do
    get 'detail', on: :member
    resources :comments, only: [:index,:create, :destroy]
  end

  resources :comments do
    get 'all', on: :member
    post 'ban', on: :member
  end

  resources :users, only: [:show,:edit,:update,:destroy] do
    post 'set_payment_password', on: :member
    patch 'update_payment_password', on: :member
  end

  resources :carts, only: [:show,:destroy] do
    get 'add_item', on: :collection
  end

  resources :items, only: [:destroy]

  resources :orders, only: [:index,:show,:create] do
    member do
      post 'preview'
      get 'payment'
      post 'paid'
    end
  end

  resources :marks, only: [:index, :create, :destroy] do
    delete 'remove', on: :member
  end

  resources :categories, only: [:show]

  resources :awards, only: [:index] do
    get 'show_all', on: :collection
    get 'judge', on: :collection
  end

  resources :coupons, only: [:index]
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
