OSTools.configure do |config|

  # schemas:migrate task runs migrations on schema_names and default_schema
  config.schema_names = lambda { OSTools::Schema.all - ['public'] }
  config.default_schema = 'public'

end
