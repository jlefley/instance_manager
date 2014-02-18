Sequel.migration do

  change do
    alter_table :instances do
      add_column :logo, String 
    end
  end

end
