ShakeReport::Application.routes.draw do
  root :to => 'reports#index'
  resources :reports do |report|
    put :update_status
  end
  resources :alert_mails, only: [:index, :create, :destroy]
end
