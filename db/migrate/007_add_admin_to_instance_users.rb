Sequel.migration do

  change do
  
    alter_table :instance_users do
      add_column :admin, TrueClass, default: false, null: false
    end

  end

end

