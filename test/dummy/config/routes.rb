Rails.application.routes.draw do
  mount Lato::Engine => "/lato"
  mount LatoSpaces::Engine => "/lato-spaces"

  root 'application#index'

  get 'documentation', to: 'application#documentation', as: :documentation
end
