module InstanceManager
  class Instance < Sequel::Model(Sequel.qualify(:public, :instances))
    
    self.raise_on_save_failure = false

    include InstanceLogic

    plugin :nested_attributes

    mount_uploader :logo, InstanceLogoUploader

    set_allowed_columns :name, :owner_attributes

    many_to_one :owner, class: 'InstanceManager::User', key: :user_id
    many_to_many :users, join_table: :instance_users
    one_to_many :instance_users, class: 'InstanceManager::InstanceUser'

    nested_attributes :owner
    
    def validate
      super
      validates_presence :name
      validates_unique :name
      errors.add :name, 'not available' if %w(www admin os).include? name and errors[:name] != 'not available'
    
      validate_logo_file_integrity
      validate_logo_file_size if logo.file
    end

    def find_user conditions
      users_dataset.where(conditions).first
    end

    def find_instance_user conditions
      instance_users_dataset.where(conditions).first
    end

    def self.first_with_id conditions
      filter(conditions).select(:id, :user_id, :name, :logo, :landing_content).first
    end

    def validate_logo_file_size
      if logo.file.size > 2.megabytes
        errors.add :logo, 'file size must be less than 2 MB'
        logo.delete_tmp
      end
    end

    def validate_logo_file_integrity
      if e = logo_integrity_error
        errors.add :logo, 'must be an image in PNG, JPEG, JPG, or GIF format'
      end
    end

    def to_json *args
      { landing_content: landing_content }.to_json
    end

  end
end
