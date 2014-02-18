Sequel.migration do

  change do
    alter_table :users do
      rename_column :admin, :system_admin
    end
  end

end
