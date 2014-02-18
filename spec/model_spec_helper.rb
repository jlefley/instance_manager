$: << File.expand_path('../../app/models/instance_manager', __FILE__)
$: << File.expand_path('../../app/domain/instance_manager', __FILE__)

require 'sequel'
require File.join(File.expand_path('../../config/initializers', __FILE__), 'sequel.rb')

Sequel.connect(YAML.load_file(File.join(File.expand_path('../../spec/dummy', __FILE__),'config','database.yml'))['test'])

RSpec.configure do |config|

  config.around :each do |example|
    Sequel::Model.db.transaction(rollback: :always) { example.run }
  end
  
  config.order = "random"

end
