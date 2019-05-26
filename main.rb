require 'sinatra'
require 'sass'
require './student'
require './comment'
require 'sinatra/reloader' if development?

configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL']|| "sqlite3://#{Dir.pwd}/development.db") #connecting to db
end

configure :development do
    DataMapper.setup(:default, ENV['DATABASE_URL']|| "sqlite3://#{Dir.pwd}/development.db") #connecting to db
end

#Getting css style sheet file

get('/style.scss'){ scss :style }

#root path
get '/' do
  	if session[:admin] == true
		erb :home, :layout => :layout2
	else
		erb :home
	end
end

#Video route
get '/video' do
	if session[:admin] == true
		erb :video, :layout => :layout2
	else
		erb :video
	end
end 

#For any other path
not_found do
 	erb :path_not_found
end
