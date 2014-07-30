require 'data_mapper'
require 'sinatra'
require './app/models/link' #this needs to be done after datamapper is initialised
require './app/models/tag'
require './app/models/user'
require 'rack-flash'
require 'sinatra/partial'
require_relative 'helpers/application'
require_relative 'data_mapper_setup'
require_relative 'controllers/sessions'
require_relative 'controllers/users'	
require_relative 'controllers/tags'
require_relative 'controllers/links'
require_relative 'controllers/application'

set :partial_template_engine, :erb


enable :sessions
set :session_secret, 'super secret'
use Rack::Flash

get '/users/reset_password' do
	erb :reset_password
end

post '/users/reset_password' do
	email = params[:email]
	user = User.first(:email => email)
	user.password_token = (1..15).map{("A".."Z").to_a.sample}.join
	user.password_token_timestamp =Time.now
	user.save
	create_link user.password_token
end

get '/users/reset_password/:token' do
	token = params[:token]
	user =User.first(:password_token => token)
	puts token
end

def create_link password_token
	request.url.to_s + "/:" + password_token.to_s
end


