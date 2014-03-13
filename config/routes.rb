ShakeReport::Application.routes.draw do
  get "applications/index"

  root :to => 'applications#index'

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'
  match 'authentication', to: 'sessions#index', as: 'authentication'

  resources :invitations, only: [:index]

  resources :applications, only: [:index , :create] do
    resources :builds, only: [:index, :create]
    resources :reports, only: [:index, :show] do
      post :create_jira_issue
      put :update_status
      put :new_build, on: :collection
      resources :comments
    end

    resources :settings, only: [:index] do
      put :update_jira
      put :add_user, on: :collection
      put :invite, on: :collection
    end
  end

  resources :reports, only: [] do
    resources :comments, controller: "reports/comments"
  end


  resources :alert_mails, only: [:index, :create, :destroy]


  #################
  #     API       #
  #################
  namespace :api do
    resources :reports, only: [:create]
  end

end