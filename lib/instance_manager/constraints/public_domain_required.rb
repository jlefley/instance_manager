module InstanceManager
  module Constraints
    class PublicDomainRequired
      def self.matches? request
        request.domain == InstanceManager.public_domain and (request.subdomain.blank? or request.subdomain == 'www')
      end
    end
  end
end
