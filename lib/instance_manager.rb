require 'instance_manager/controller_helpers'
require 'instance_manager/engine'
require 'sequel_rails'
require 'orm_adapter-sequel'
require 'devise'
require 'instance_manager/rails/routes'
require 'dynamic_form'
require 'carrierwave'
require 'carrierwave/sequel'

module InstanceManager

  attr_accessor :public_domain, :restricted_subdomains, :public_instance_schema

  extend self

  def current_schema_default?
    OSTools::Schema.search_path.match(OSTools.default_schema) ? true : false
  end

  def current_schema_public?
    OSTools::Schema.search_path.match(InstanceManager.public_instance_schema) ? true : false
  end

  def qualified_users_table
    if current_schema_public?
      "#{InstanceManager.public_instance_schema}__users".to_sym
    else
      "#{OSTools.default_schema}__users".to_sym
    end
  end

  def create_instance request, current_user
    Sequel::Model.db.transaction do
      CreateInstanceService.new(user: User, instance: Instance, schema_tools: OSTools).command request, current_user
    end
  end

  def complete_instance_creation user, current_instance
    Sequel::Model.db.transaction do
      CompleteInstanceCreationService.new(user: User, schema_tools: OSTools).command user, current_instance
    end
  end

end
