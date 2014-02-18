module InstanceManager
  class InstanceUser < Sequel::Model(Sequel.qualify(:public, :instance_users))
 
    self.raise_on_save_failure = false
 
    many_to_one :user, class: 'InstanceManager::User'
    many_to_one :instance, class: 'InstanceManager::Instance'
    many_to_one :creator, class: 'InstanceManager::User'

    def validate
      super
      validates_unique [:user_id, :instance_id]
    end

  end
end
