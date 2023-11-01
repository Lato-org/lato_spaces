Rails.application.routes.draw do
  mount Lato::Engine => "/adm"
  mount LatoSpaces::Engine => "/adm/spcs"

  root 'application#index'
end
