require 'bcrypt'

class User

	include DataMapper::Resource

	property :id, Serial
	property :email, String, :unique => true, :message => "Email is already registered"
	# this will store both the password and the salt
	# It's Text and not String because String holds 
	# 50 characters by default
	# and it's not enough for the hash and salt

	property :password_digest, Text
	property :password_token, Text
	property :password_token_timestamp, Time

	attr_reader :password
	attr_accessor :password_confirmation
	validates_confirmation_of :password, :message => "Ooops...your passwords do not match!"

	# when assigned the password, we don't store it directly
	# instead, we generate a password digest, that looks like this:
	# "$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa"
	# and save it in the database. This digest, provided by bcrypt,
	# has both the password hash and the salt. We save it to the 
	# database instead of the plain password for security reasons.

	def password=(password)
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end

	def set_reset_token
		update(password_token: (1..60).map{("A".."Z").to_a.sample}.join,
		password_token_timestamp: Time.now)
	end

	def self.authenticate(email, password)
		user = first(:email => email)
		if user && BCrypt::Password.new(user.password_digest) == password
			user
		else
			nil
		end
	end

	def reset_password(password,password_confirmation)	
		if update(:password => password,
				 :password_confirmation => password_confirmation)
			update(:password_token => nil,
				 :password_token_timestamp => nil)
		else
			false
		end
	end

end