ShakeReport::Application.routes.draw do
  root :to => 'reports#index'

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'
  match 'authentication', to: 'sessions#index', as: 'authentication'

  resources :reports, only: [:index, :show] do |report|
    post :create_jira_issue
    put :update_status
    put :new_build, on: :collection
    resources :comments
  end
  resources :settings, only: [:index] do
   put :update_jira
  end
  resources :alert_mails, only: [:index, :create, :destroy]


  #################
  #     API       #
  #################
  namespace :api do
    resources :reports, only: [:create]
  end

end
