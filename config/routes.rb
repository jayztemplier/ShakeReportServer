ShakeReport::Application.routes.draw do
  root :to => 'reports#index'  
  resources :reports, only: [:index, :create, :show] do |report|
    post :create_jira_issue
    put :update_status
    put :new_build, on: :collection
    resources :comments
  end
  resources :settings, only: [:index] do
   put :update_jira
  end
  resources :alert_mails, only: [:index, :create, :destroy]
end
