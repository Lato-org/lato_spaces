LatoSpaces::Engine.routes.draw do
  root 'application#index'

  scope :groups do
    get '', to: 'groups#index', as: :groups
    get 'create', to: 'groups#create', as: :groups_create
    post 'create_action', to: 'groups#create_action', as: :groups_create_action
    get 'update/:id', to: 'groups#update', as: :groups_update
    patch 'update_action/:id', to: 'groups#update_action', as: :groups_update_action
    delete 'destroy_action/:id', to: 'groups#destroy_action', as: :groups_destroy_action
  end
end
