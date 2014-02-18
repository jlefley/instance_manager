require 'instance_manager/constraints/subdomain_prohibited.rb'

InstanceManager::Engine.routes.draw do

  constraints InstanceManager::Constraints::PublicDomainRequired do

    devise_for :public_users, class_name: 'InstanceManager::PublicInstance::User', module: :devise, path: 'users',
      skip: [:registrations, :sessions, :passwords], controllers: { confirmations: 'instance_manager/public_instance/confirmations' }
  
    devise_scope :public_user do
      resource :registration, only: [:create, :update], path: 'users', controller: 'public_instance/registrations',
        as: :public_user_registration
      resource :password, only: [:create, :edit, :update], path: 'users/password', controller: 'public_instance/passwords',
        as: :public_user_password
      post '/users/sign_in' => 'public_instance/sessions#create', as: :public_user_session
      delete '/users/sign_out' => 'public_instance/sessions#destroy', as: :destroy_public_user_session
    end

  end

  constraints InstanceManager::Constraints::SubdomainRequired do
   
    constraints subdomain: 'admin' do
      scope module: :system do
        resources :instances, only: [:create, :new]
      end
    end

    devise_for :private_users, class_name: 'InstanceManager::User', module: :devise, path: 'users', skip: :registrations,
      controllers: { confirmations: 'instance_manager/instance/confirmations', passwords: 'instance_manager/instance/passwords',
      sessions: 'instance_manager/instance/sessions' }
    
    devise_scope :private_user do
      patch '/users/confirmation' => 'instance/confirmations#confirm', as: :private_user_confirm
      resource :registration, only: [:new, :create, :update], path: 'users', controller: 'instance/registrations',
        as: :private_user_registration
    end
    
    namespace :admin, module: :instance, as: :instance_admin do
      root to: 'admin#index', as: :index
    end

    scope module: :instance do    
      resources :instance_logos, only: [:index, :create]
    end

  end
  
  constraints InstanceManager::Constraints::SubdomainProhibited do
 
    scope module: :instance do
      resources :accounts, only: [:create, :new]
    end

  end

  patch '/instances' => 'system/instances#update'

end
