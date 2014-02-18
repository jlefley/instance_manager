# This migration comes from instance_manager (originally 2)
require 'os_tools/sequel/triggers'

Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      String :email, null: false, unique: true
      String :username, null: false, unique: true
      String :encrypted_password, null: false
      String :reset_password_token
      column :reset_password_sent_at, 'timestamp with time zone'
      column :remember_created_at, 'timestamp with time zone'
      Integer :sign_in_count, default: 0
      column :current_sign_in_at, 'timestamp with time zone'
      column :last_sign_in_at, 'timestamp with time zone'
      String :current_sign_in_ip
      String :last_sign_in_ip
      String :confirmation_token
      column :confirmed_at, 'timestamp with time zone'
      column :confirmation_sent_at, 'timestamp with time zone'
      String :unconfirmed_email
      Integer :failed_attempts, default: 0
      TrueClass :admin, default: false, null: false
      column :locked_at, 'timestamp with time zone'
      column :created_at, 'timestamp with time zone', null: false
    end
    created_at_trigger :users
  end

  down do
    drop_table :users
    drop_created_at_trigger :users
  end
end
