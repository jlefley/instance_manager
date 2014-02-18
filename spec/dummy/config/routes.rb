Rails.application.routes.draw do

  instance_manager_root_routes false

  root to: 'main#index'
  resources :things, only: [:index]
  resources :items, only: [:index]
  
  mount InstanceManager::Engine => '/'

end
