LatoSpaces::Engine.routes.draw do
  root 'application#index'

  scope :spaces do
    get '', to: 'spaces#index', as: :spaces
    get 'create', to: 'spaces#create', as: :spaces_create
    post 'create_action', to: 'spaces#create_action', as: :spaces_create_action
    get 'update/:id', to: 'spaces#update', as: :spaces_update
    patch 'update_action/:id', to: 'spaces#update_action', as: :spaces_update_action
    delete 'destroy_action/:id', to: 'spaces#destroy_action', as: :spaces_destroy_action
    get 'members/:id', to: 'spaces#members', as: :spaces_members
    get 'members/:id/create', to: 'spaces#members_create', as: :spaces_members_create
    post 'members/:id/create_action', to: 'spaces#members_create_action', as: :spaces_members_create_action
    post 'members/send_invite_action/:id', to: 'spaces#members_send_invite_action', as: :spaces_members_send_invite_action
    get 'members/destroy_action/:id', to: 'spaces#members_destroy_action', as: :spaces_members_destroy_action
  end
end
