#This class corresponds to a table in our database
#We can use it to manipulate data

class Link

	# this makes the instances of this class  Datamapper resources
	include DataMapper::Resource

	#This block describes what resources our model has
	property :id,     Serial # Serial means that it will be auto-incremented for every record
	property :title,  String
	property :url,    String

end