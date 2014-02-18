# This migration comes from instance_manager (originally 10)
Sequel.migration do

  change do
  
    alter_table :users do
      add_column :username, String, unique: true
    end

  end

end
