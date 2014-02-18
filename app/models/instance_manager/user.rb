module InstanceManager
  class User < Sequel::Model(Sequel.qualify(:public, :users))

    self.raise_on_save_failure = false

    plugin :devise
    plugin :dirty
    plugin :nested_attributes

    attr_accessor :subdomain
    before_create :valid?
    set_allowed_columns :email, :password, :password_confirmation, :remember_me, :instances_attributes, :account_attributes
    
    one_to_many :instance_users
    one_to_many :instances
    one_to_one :account
    
    nested_attributes :instances
    nested_attributes :account

    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :confirmable, :lockable,
      :timeoutable, authentication_keys: [ :email ], request_keys: [ :subdomain ], confirmation_keys: [ :email, :subdomain ],
      reset_password_keys: [ :email, :subdomain ]
   
    include UserLogic
    include PrivateUserLogic
    extend PrivateUserLogic::ClassMethods

    class << self
      def find_within_instance subdomain, user_conditions
        select(Sequel.expr(:users).*).join(:public__instance_users, user_id: :id).join(:public__instances, id: :instance_id).
          filter(user_conditions.merge(name: subdomain)).first
      end

      def reset_password_by_token(attributes={})
        keys = [:reset_password_token, :subdomain]
        
        original_token = attributes[:reset_password_token]
        attributes[:reset_password_token] = Devise.token_generator.digest(self, :reset_password_token, original_token)
        recoverable = find_or_initialize_with_errors(keys, attributes.symbolize_keys.select { |k,v| keys.include? k })

        if recoverable.persisted?
          if recoverable.reset_password_period_valid?
            recoverable.reset_password!(attributes[:password], attributes[:password_confirmation])
          else
            recoverable.errors.add(:reset_password_token, :expired)
          end
        end

        recoverable.reset_password_token = original_token 
        recoverable
      end
   
      def find_by_confirmation_token_and_subdomain confirmation_token, subdomain
        original_token     = confirmation_token
        confirmation_token = Devise.token_generator.digest(self, :confirmation_token, confirmation_token)
        confirmable = find_or_initialize_with_errors(
          [:confirmation_token, :subdomain], { subdomain: subdomain, confirmation_token: confirmation_token }
        )
        confirmable.confirmation_token = original_token
        confirmable
      end
    end

    def find_instance_relationship instance_id
      instance_users_dataset.filter(instance_id: instance_id).first
    end

    def to_json *args
      as_json.to_json
    end

    def as_json
      { username: username, email: email }
    end

    def scope
      :private_user
    end

    def before_create
      loop do
        self.username = generate_username
        break unless self.class.first username: username
      end
    end

    def generate_username
      (0..9).to_a.shuffle[0,8].join
    end

    def confirm_by_token! confirmation_token
      original_token = confirmation_token
      confirm!
      self.confirmation_token = original_token
    end

  end
end
