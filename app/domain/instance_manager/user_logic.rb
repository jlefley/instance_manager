module InstanceManager
  module UserLogic

    attr_reader :raw_confirmation_token

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    VALID_PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+\z/

    def email_changed?
      column_changed? :email
    end

    def email_was
      initial_value :email
    end

    def validate
      super
      validates_presence :email, message: 'required'
      
      if password_required?
        validates_presence :password, message: 'required'
        validates_format VALID_PASSWORD_REGEX, :password, message: 'must contain a-z, A-Z, and 0-9'
        validates_length_range 8..100, :password, message: 'must be between 8 and 100 characters'
      end

      validates_unique :email, message: 'already taken'
      validates_format VALID_EMAIL_REGEX, :email, message: 'invalid'
      errors.add(:password, 'does not match confirmation') if password != password_confirmation
    end

    # Update method to bypass mass assignment protection
    # Devise/Warden hook sets failed attempts with this method
    def update_attribute key, value
      setter = :"#{key}="
      send(setter, value) if respond_to?(setter)
      save(:changes => true, :validate => false)
    end

    def assign_attributes params, *options
      set params
    end
  end
end
