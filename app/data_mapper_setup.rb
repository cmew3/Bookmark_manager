env = ENV["RACK_ENV"] || "development"
#We're telling datamapper to use a postgres database on localhost. The name will be "bookmark_manager_test"
# A generic format for rhw connection string is dbtype://user:password@hostname:port/databasename
#By default postgres is configured to accept connections from a loggin in user without password and with default port so we omit them here
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

# After declaring your models, you should finalize them
DataMapper.finalize

#Hoever, the database tables don't exist yet. We then tell the datamapper to create them
DataMapper.auto_upgrade!
# auto_upgrade makes non-destructive changes. It your tables don't exist, they will be created
# but if they do and you changed your schema (e.g. changed the type of one of the properties)
# they will not be upgraded because that'd lead to data loss.
# To force the creation of all tables as they are described in your models, even if this
# leads to data loss, use auto_migrate:
# DataMapper.auto_migrate!
# Finally, don't forget that before you do any of that stuff, you need to create a database first.