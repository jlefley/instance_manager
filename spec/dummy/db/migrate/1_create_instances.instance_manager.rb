# This migration comes from instance_manager (originally 1)
require 'os_tools/sequel/triggers'

Sequel.migration do
  up do
    create_table :instances do
      primary_key :id
      String :name, null: false, unique: true
      column :updated_at, 'timestamp with time zone', null: false
      column :created_at, 'timestamp with time zone', null: false
    end
    created_at_trigger :instances
    updated_at_trigger :instances
  end

  down do
    drop_table :instances
    drop_created_at_trigger :instances
    drop_updated_at_trigger :instances
  end
end
