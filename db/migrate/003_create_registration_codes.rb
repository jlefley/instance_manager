require 'os_tools/sequel/triggers'

Sequel.migration do
  up do
    create_table :registration_codes do
      String :code, primary_key: true
      foreign_key :user_id, :users
      column :created_at, 'timestamp with time zone', null: false
    end 

    created_at_trigger :registration_codes
    
    alter_table :registration_codes do
      set_column_allow_null :user_id, true
    end 
  end 

  down do
    drop_table :registration_codes
    drop_created_at_trigger :registration_codes
  end
end
