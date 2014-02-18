# This migration comes from instance_manager (originally 8)
Sequel.migration do

  up do
    alter_table :users do
      drop_column :username
    end
  end

  down do
    alter_table :users do
      add_column :username, String, null: false, unique: true
    end
  end

end
