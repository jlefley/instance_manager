# This migration comes from instance_manager (originally 9)
Sequel.migration do
  
  up do
  
    alter_table :users do
      set_column_allow_null :encrypted_password
    end

  end

  down do
  
    alter_table :users do
      set_column_not_null :encrypted_password
    end

  end

end
