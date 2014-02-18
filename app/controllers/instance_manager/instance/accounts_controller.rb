module InstanceManager
  class Instance::AccountsController < ::ApplicationController

    layout false

    def new
      build_objects 
    end

    def set_errors source, target
      source.errors.each do |field, errors|
        errors.each do |error|
          target.errors.add :instances, "#{field} #{error}"
        end
      end
    end

    def create
# New create method code below
      # See if user exists
      existing_user = User.first(email: params[:user][:email])
      if existing_user
        # Create the new instance
        @instance = Instance.new(name: params[:user][:instances_attributes]['0'][:name])
        # Associate user as owner of instance
        @instance.owner = existing_user
        if @instance.save
          # Add user as admin to instance
          @instance.add_admin user: existing_user, creator: existing_user
          # Create schema
          OSTools.create_schema(@instance.id.to_s)
          # Seed instance with data
          OSTools.load_seed(@instance.id.to_s)
          # Set a flash notice stating that a new instance was creatd with an exisitng account
          flash[:notice] = 'New instance created for existing account; please visit the new subdomain to log in.'
          # Call build_objects so new form can be rendered
          build_objects
        else
          # Create user object for form
          @user = User.new email: params[:user][:email]
          # Create an account object for form
          @account = Account.new
          # Workaround to show errors when instance is invalid and user exists
          set_errors(@instance, @user)
        end
      else

# Old create method code below
        @user = User.new params[:user]
        instance = @user.instances.first
        Thread.current[:request_host] = instance.try(:name) + '.' + request.domain
        if @user.save
          instance.add_admin user: @user, creator: @user
          flash[:notice] = 'Account created, check email for confirmation link'
          build_objects
        else
          @user.clean_up_passwords if @user.respond_to?(:clean_up_passwords)
        end
# Commenting out of old code
#        render :new
      end
# Added here to always call it
      render :new
    end

    private

    def build_objects
      @user = User.new
      @account = Account.new
      @instance = Instance.new
    end

  end
end
