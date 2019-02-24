Rails.application.routes.draw do
  resources :homeowners do
    collection do
      get :payments
      post :process_payments
    end
  end
  resources :streets
  resources :reports, only: [:index]
  root to: 'homeowners#index'
  get 'home/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
