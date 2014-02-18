Sequel.migration do

  name = InstanceManager.public_instance_schema

  up do
    if OSTools::Schema.search_path.match(/public/)
      OSTools::Database.dump_structure File.expand_path(File.join(Rails.root, 'db', 'schema_structure.sql'))
      OSTools.create_schema name, false
      run %(UPDATE #{name}.schema_info SET version = 12)
    end
  end

  down do
    run %(DROP SCHEMA #{name} CASCADE)
  end

end
