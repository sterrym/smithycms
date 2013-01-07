Rails.application.routes.draw do
  devise_for :users
debugger
  resources :tests
  match '/users/sign_in', :to => "devise/sessions#new", :as => "sign_in"
  match '/users/:id', :to => "users#show", :as => "user"

  mount Smithy::Engine => "/"
end
