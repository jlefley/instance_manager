module InstanceManager
  module Constraints
    class SubdomainRequired
      def self.matches? request
        request.subdomain.present? and request.subdomain != 'www'
      end
    end
  end
end
