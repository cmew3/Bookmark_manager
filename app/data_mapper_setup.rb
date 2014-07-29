env = ENV["RACK_ENV"] || "development"
#We're telling datamapper to use a postgres database on localhost. The name will be "bookmark_manager_test"
# A generic format for rhw connection string is dbtype://user:password@hostname:port/databasename
#By default postgres is configured to accept connections from a loggin in user without password and with default port so we omit them here
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

# After declaring your models, you should finalize them
DataMapper.finalize
