Sequel.migration do
  change do
    create_table(:schema_info) do
      column :version, "integer", :default=>0, :null=>false
    end
    
    create_table(:users) do
      primary_key :id
      column :email, "text", :null=>false
      column :reset_password_token, "text"
      column :reset_password_sent_at, "timestamp with time zone"
      column :remember_created_at, "timestamp with time zone"
      column :sign_in_count, "integer", :default=>0
      column :current_sign_in_at, "timestamp with time zone"
      column :last_sign_in_at, "timestamp with time zone"
      column :current_sign_in_ip, "text"
      column :last_sign_in_ip, "text"
      column :confirmation_token, "text"
      column :confirmed_at, "timestamp with time zone"
      column :confirmation_sent_at, "timestamp with time zone"
      column :unconfirmed_email, "text"
      column :failed_attempts, "integer", :default=>0
      column :system_admin, "boolean", :default=>false, :null=>false
      column :locked_at, "timestamp with time zone"
      column :created_at, "timestamp with time zone", :null=>false
      column :encrypted_password, "text"
      
      index [:email], :name=>:users_email_key, :unique=>true
    end
    
    create_table(:instances) do
      primary_key :id
      column :name, "text", :null=>false
      column :updated_at, "timestamp with time zone", :null=>false
      column :created_at, "timestamp with time zone", :null=>false
      foreign_key :user_id, :users, :null=>false, :key=>[:id]
      
      index [:name], :name=>:instances_name_key, :unique=>true
    end
    
    create_table(:registration_codes) do
      column :code, "text", :null=>false
      foreign_key :user_id, :users, :key=>[:id]
      column :created_at, "timestamp with time zone", :null=>false
      
      primary_key [:code]
    end
    
    create_table(:instance_users) do
      foreign_key :user_id, :users, :null=>false, :key=>[:id]
      foreign_key :instance_id, :instances, :null=>false, :key=>[:id]
      foreign_key :creator_id, :users, :null=>false, :key=>[:id]
      column :created_at, "timestamp with time zone", :null=>false
      column :admin, "boolean", :default=>false, :null=>false
      
      primary_key [:user_id, :instance_id]
      
      index [:instance_id]
    end
  end
end
