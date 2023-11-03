Rails.application.routes.draw do
  mount Lato::Engine => "/adm"
  mount LatoSpaces::Engine => "/adm/spaces"

  root 'application#index'

  get 'documentation', to: 'application#documentation', as: :documentation
end
