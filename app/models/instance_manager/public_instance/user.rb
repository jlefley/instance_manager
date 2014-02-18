module InstanceManager
  module PublicInstance
    class User < Sequel::Model(Sequel.qualify(InstanceManager.public_instance_schema.to_sym, :users))
 
      self.raise_on_save_failure = false
     
      plugin :devise
      plugin :dirty

      before_create :valid?
      
      devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :confirmable, :lockable,
        :timeoutable, authentication_keys: [ :username ], confirmation_keys: [ :email ], reset_password_keys: [ :email ]
      
      include UserLogic
      
      def to_json *args
        { username: username, admin: admin }.to_json
      end

      def validate
        super
        validates_presence :username, message: 'required'
        validates_unique :username, message: 'already taken'
        validates_max_length 50, :username, message: 'too long'
        check_username
      end

      def check_username
        reserved = %w(jlefley jason\ lefley jasonlefley jwl dan\ wolff danwolff drw jjwl89)
        if reserved.include? username and !errors[:username].include? 'already taken'
          errors.add :username, 'already taken'
        end
      end

      def scope
        :public_user
      end

      private
     
      def password_required?
        !persisted? || !password.nil? || !password_confirmation.nil?
      end

    end
  end
end
