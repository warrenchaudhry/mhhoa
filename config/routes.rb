Rails.application.routes.draw do
  resources :homeowners
  resources :streets
  root to: 'homeowners#index'
  get 'home/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
