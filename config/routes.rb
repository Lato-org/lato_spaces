LatoSpaces::Engine.routes.draw do
  root 'application#index'

  resources :spaces, except: :show do
  end
end
