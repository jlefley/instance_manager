module InstanceManager
  class SchemaSelector
 
    attr_reader :schema_tools

    def initialize app, schema_tools
      @app = app
      @schema_tools = schema_tools
    end

    def call env
    
      host = Rack::Request.new(env).host

      if select_domain(host) == (public_domain = select_domain(InstanceManager.public_domain))
        env['current_instance'] = lookup_instance public_domain
        schema_tools.switch(InstanceManager.public_instance_schema, false)
      elsif (subdomain = select_subdomain(host)) and (current_instance = lookup_instance(subdomain))
        env['current_instance'] = current_instance
        set_instance_search_path current_instance, subdomain 
      else
        schema_tools.reset
      end

      @app.call(env)
    end

    private

    def lookup_instance subdomain
      Instance.first_with_id name: subdomain
    end

    def set_instance_search_path current_instance, subdomain
      if InstanceManager.restricted_subdomains.include? subdomain
        schema_tools.reset
      else
        begin
          schema_tools.switch(current_instance.id, false)
        rescue
          schema_tools.reset
        end
      end
    end

    # *Almost* a direct ripoff of ActionDispatch::Request subdomain methods
    
    # Only care about the first subdomain for the database name
    def select_subdomain host
      subdomains(host).first
    end

    # Assuming tld_length of 1, might need to make this configurable in the future for things like .co.uk
    def subdomains host, tld_length = 1
      return [] unless named_host?(host)

      host.split('.')[0..-(tld_length + 2)]
    end

    def named_host? host
      !(host.nil? || /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.match(host))
    end

    def select_domain host
      return nil if host.blank?

      host.match(/(www.)?(?<sld>[^.]*)/)["sld"]
    end

  end
end
