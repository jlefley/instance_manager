# This migration comes from instance_manager (originally 13)
Sequel.migration do
  
  if InstanceManager.current_schema_public?
    change do
      alter_table :users do
        add_column :admin, TrueClass, default: false, null: false
      end
    end
  end

end
