namespace :instance_manager do
  namespace :public_instance do
    desc "Create a schema for the public instance and load the structure from db/schema_structure.rb"
    task create_schema: :environment do
      OSTools::Schema.create InstanceManager.public_instance_schema
      OSTools::Schema.switch InstanceManager.public_instance_schema, false
      OSTools::Database.load_structure File.join(Rails.root, 'db', 'schema_structure.sql'), false
      OSTools::Schema.reset
    end
  end
end
