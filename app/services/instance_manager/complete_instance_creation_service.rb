module InstanceManager
  class CompleteInstanceCreationService

    attr_reader :schema_tools, :user_repository

    def initialize dependencies
      @schema_tools, @user_repository = dependencies.values_at :schema_tools, :user
    end

    def command user, current_instance
      return if current_instance.nil? or current_instance.user_id != user.id or user.confirmed?
      
      schema_tools.create_schema current_instance.id.to_s
      schema_tools.load_seed current_instance.id.to_s
    end

  end
end
