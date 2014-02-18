Sequel.migration do

  change do
    alter_table :instances do
      add_column :landing_content, String 
    end
  end

end
