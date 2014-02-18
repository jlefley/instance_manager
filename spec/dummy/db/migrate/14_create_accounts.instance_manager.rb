# This migration comes from instance_manager (originally 12)
require 'os_tools/sequel/triggers'

Sequel.migration do

  if OSTools::Schema.search_path.match OSTools.default_schema
    up do
      create_table :accounts do
        primary_key :id
        foreign_key :user_id, :users, null: false
        String :last_name, null: false
        String :first_name, null: false
        String :organization
        Bignum :phone_number
        column :created_at, 'timestamp with time zone', null: false
        column :updated_at, 'timestamp with time zone', null: false
      end
      created_at_trigger :accounts
      updated_at_trigger :accounts
    end
    
    down do
      drop_table :accounts
      drop_created_at_trigger :accounts
      drop_updated_at_trigger :accounts
    end
  end

end
