module InstanceManager
  module Constraints
    class SubdomainProhibited
      def self.matches? request
        !request.subdomain.present? or request.subdomain == 'www'
      end
    end
  end
end
