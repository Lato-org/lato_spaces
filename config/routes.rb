LatoSpaces::Engine.routes.draw do
  root 'application#index'
  post 'setgroup/:id', to: 'application#setgroup', as: :setgroup

  scope :groups do
    get '', to: 'groups#index', as: :groups
    get 'create', to: 'groups#create', as: :groups_create
    post 'create_action', to: 'groups#create_action', as: :groups_create_action
    get 'show/:id', to: 'groups#show', as: :groups_show
    get 'update/:id', to: 'groups#update', as: :groups_update
    patch 'update_action/:id', to: 'groups#update_action', as: :groups_update_action
    delete 'destroy_action/:id', to: 'groups#destroy_action', as: :groups_destroy_action
  end

  scope :memberships do
    get 'create/:group_id', to: 'memberships#create', as: :memberships_create
    post 'create_action/:group_id', to: 'memberships#create_action', as: :memberships_create_action
    delete 'destroy_action/:id', to: 'memberships#destroy_action', as: :memberships_destroy_action
    post 'send_invite_action/:id', to: 'memberships#send_invite_action', as: :memberships_send_invite_action
  end
end
