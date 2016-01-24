# using this file to load anything an application file may need

require 'active_record'
require 'unirest'

ROOT = File.expand_path '../..', __FILE__

# setup the database
include ActiveRecord::Tasks

DatabaseTasks.env = ENV['ENV'] || 'development'
DatabaseTasks.database_configuration = YAML.load(File.read(File.join(ROOT, 'config/database.yml')))
DatabaseTasks.db_dir = File.join ROOT, 'db'
DatabaseTasks.fixtures_path = File.join ROOT, 'test/fixtures'
DatabaseTasks.migrations_paths = [File.join(ROOT, 'db/migrate')]
DatabaseTasks.root = ROOT
ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym

# load all the models
Dir.glob(File.join(ROOT, 'app/models/*.rb')).each do |model_file|
  require model_file
end

# load all the lib files
Dir.glob(File.join(ROOT, 'lib/*.rb')).each do |lib_file|
  require lib_file
end

# load the secrets
SECRETS = YAML.load(File.read(File.join(ROOT, 'config/secrets.yml')))