# This migration comes from instance_manager (originally 15)
Sequel.migration do

  change do
    alter_table :instances do
      add_column :logo, String 
    end
  end

end
