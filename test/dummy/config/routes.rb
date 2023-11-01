Rails.application.routes.draw do
  mount Lato::Engine => "/adm"
  mount LatoSpaces::Engine => "/adm/spaces"
end
