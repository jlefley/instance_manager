require 'os_tools/sequel/triggers'

Sequel.migration do

  up do
    create_table :instance_users do
      foreign_key :user_id, :users
      foreign_key :instance_id, :instances
      foreign_key :creator_id, :users, null: false
      column :created_at, 'timestamp with time zone', null: false
      primary_key [:user_id, :instance_id]
      index :instance_id
    end
    created_at_trigger :instance_users
  end

  down do
    drop_table :instance_users
    drop_created_at_trigger :instance_users
  end

end

