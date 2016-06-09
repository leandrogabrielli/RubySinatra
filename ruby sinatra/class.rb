require 'rubygems'
require 'dm-core'
require 'dm-migrations'
require 'data_mapper'
gem 'rb-readline'

DataMapper.setup :default, "sqlite3://#{Dir.pwd}/database.db"

 
class Software
	include DataMapper::Resource
	property :id, Serial
	property :title, String
	property :description, Text
	property :language, String
end

class ApplicationController < Sinatra::Base
  enable :sessions
end

DataMapper.finalize
