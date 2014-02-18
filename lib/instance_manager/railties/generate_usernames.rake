namespace :instance_manager do
  desc 'Generate random, numeric username for private instance users'
  task generate_usernames: :environment do
    InstanceManager::User.all.each do |u|
      u.before_create
      u.save validate: false
    end
  end
end
