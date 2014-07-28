require 'data_mapper'
require 'sinatra'

env = ENV["RACK_ENV"] || "development"
#We're telling datamapper to use a postgres database on localhost. The name will be "bookmark_manager_test"
# A generic format for rhw connection string is dbtype://user:password@hostname:port/databasename
#By default postgres is configured to accept connections from a loggin in user without password and with default port so we omit them here
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require './lib/link' #this needs to be done after datamapper is initialised

# After declaring your models, you should finalize them
DataMapper.finalize

#Hoever, the database tables don't exist yet. We then tell the datamapper to create them
DataMapper.auto_upgrade!

get '/' do
	@links =Link.all
	erb :index
end