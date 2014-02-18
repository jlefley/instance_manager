# This migration comes from instance_manager (originally 16)
Sequel.migration do

  change do
    alter_table :instances do
      add_column :landing_content, String 
    end
  end

end
