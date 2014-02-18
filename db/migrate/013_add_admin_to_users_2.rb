Sequel.migration do
  
  if InstanceManager.current_schema_public?
    change do
      alter_table :users do
        add_column :admin, TrueClass, default: false, null: false
      end
    end
  end

end
