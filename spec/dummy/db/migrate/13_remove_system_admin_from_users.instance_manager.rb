# This migration comes from instance_manager (originally 11)
Sequel.migration do

  up do
    alter_table :users do
      drop_column :system_admin
    end
  end

  down do
    alter_table :users do
      add_column :system_admin, TrueClass, default: false, null: false
    end
  end

end
