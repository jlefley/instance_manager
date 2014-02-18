module InstanceManager
  class Account < Sequel::Model(:public__accounts)

    self.raise_on_save_failure = false

    set_allowed_columns :first_name, :last_name, :organization, :phone_number

    def validate
      super
      validates_presence :last_name
      validates_presence :first_name
    end

    def phone_number= value
      super value.gsub /\D/, ''
    end

  end
end
