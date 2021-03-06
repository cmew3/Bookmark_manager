require 'data_mapper'
require 'sinatra'
require './app/models/link' #this needs to be done after datamapper is initialised
require './app/models/tag'
require './app/models/user'
require 'rack-flash'
require 'sinatra/partial'
require 'rest-client'
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




