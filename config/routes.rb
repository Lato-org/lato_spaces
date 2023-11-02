LatoSpaces::Engine.routes.draw do
  root 'application#index'

  scope :spaces do
    get '', to: 'spaces#index', as: :spaces
    get 'create', to: 'spaces#create', as: :spaces_create
    post 'create_action', to: 'spaces#create_action', as: :spaces_create_action
    get 'update/:id', to: 'spaces#update', as: :spaces_update
    patch 'update_action/:id', to: 'spaces#update_action', as: :spaces_update_action
    delete 'destroy_action/:id', to: 'spaces#destroy_action', as: :spaces_destroy_action

    get 'members', to: 'spaces#members', as: :spaces_members
  end

  # resources :spaces, except: :show do
  #   get :members, on: :member
  #   get :new_member, on: :member
  #   post :create_member, on: :member
  #   post :reinvite_member, on: :member
  #   delete :remove_member, on: :member
  # end
end
