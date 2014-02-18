module InstanceManager
  module PrivateUserLogic
 
    module ClassMethods
     
      def find_first_by_auth_conditions conditions
        conditions = devise_parameter_filter.filter(conditions).symbolize_keys
        subdomain = conditions.delete(:subdomain)
        
        if subdomain.nil? or %w(www).include? subdomain
          nil
        else
          find_within_instance(subdomain, conditions)
        end

      end
    
    end

    def instance_admin? instance
      find_instance_relationship(instance.id).admin
    end

    def instance_user? instance
      find_instance_relationship(instance.id) ? true : false
    end

    def password_required?
      if persisted?
        if encrypted_password
          !password.nil? || !password_confirmation.nil?
        else
          true
        end
      else
        if instances.present? and !instances.first.persisted?
          true
        else
          false
        end
      end
    end

  end
end
