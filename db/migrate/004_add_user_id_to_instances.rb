Sequel.migration do

  change do
    alter_table :instances do
      add_foreign_key :user_id, :users, null: false
    end
  end


end
