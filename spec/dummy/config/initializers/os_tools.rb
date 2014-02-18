OSTools.configure do |config|
  config.seed << { table: :things, columns: [:name] }
end
