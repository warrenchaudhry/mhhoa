Rails.application.routes.draw do
  resources :homeowners
  resources :streets
  resources :reports, only: [:index]
  resources :payments, only: [:index] do
    collection do
      get :batch
      post :process_batch
    end
  end
  root to: 'homeowners#index'
  get 'home/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
