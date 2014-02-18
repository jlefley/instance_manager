require 'instance_manager/constraints/public_domain_required'
require 'instance_manager/constraints/subdomain_required'

module ActionDispatch::Routing
  class Mapper

    def instance_manager_root_routes require_authentication_for_public_instance=true

      if require_authentication_for_public_instance
        constraints InstanceManager::Constraints::PublicDomainRequired do
          unauthenticated :public_user do
            as :public_user do
              root to: 'instance_manager/public_instance/sessions#new', as: :unauthenticated_public_user_root
            end
          end
        end
      end
      
      constraints InstanceManager::Constraints::SubdomainRequired do
        unauthenticated :private_user do
          as :private_user do
            root to: 'instance_manager/instance/sessions#new', as: :unauthenticated_private_user_root
          end
        end
        
        constraints subdomain: 'admin' do
          root to: 'instance_manager/system/admin#index', as: :system_admin_index
        end
      end

    end
    
  end
end
