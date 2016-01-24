require File.join(Dir.pwd, 'config/loader.rb')
ActiveRecord::Base.logger = Logger.new STDOUT