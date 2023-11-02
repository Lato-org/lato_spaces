LatoSpaces::Engine.routes.draw do
  root 'application#index'

  resources :spaces, except: :show do
    get :members, on: :member
    get :new_member, on: :member
    post :create_member, on: :member
    post :reinvite_member, on: :member
    delete :remove_member, on: :member
  end
end
