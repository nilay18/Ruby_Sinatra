
require 'dm-core'
require 'dm-migrations'
require './main'
require './comment'
require 'sinatra/reloader' if development?

#enable :sessions
DataMapper.setup(:default, ENV['DATABASE_URL']|| "sqlite3://#{Dir.pwd}/development.db")
configure do
  enable :sessions
  set :username, "skynet"
  set :password, "deadshot76"
end


class Student
  include DataMapper::Resource
  property :id, Serial
  property :firstname, String
  property :lastname, String
  property :birthday, Date
  property :address, String
  property :studentid, String

  def birthday=date
    super Date.strptime(date, '%m/%d/%Y')
  end
end

DataMapper.finalize
#DataMapper.auto_migrate!
DataMapper.auto_upgrade!

get '/students' do
  @students = Student.all
  if session[:admin] == true
    erb :students, :layout => :layout2
  else
    erb :students, :layout => :layout1
  end
end

get '/login' do
  erb :login
end

post '/login' do
  if params[:username] == settings.username && params[:password] == settings.password
      session[:admin] = true
      erb :logged, :layout => :layout2
  else
    erb :login
  end
end

get '/logout' do
session.clear
session[:admin] = false
erb :login, :layout => :layout1

end

#New student form
get '/students/new' do
  redirect to('/logout') unless session[:admin]
  @student = Student.new
  erb :new_student, :layout => :layout2
end

#Individual student record
get '/students/:id' do
  @student = Student.get(params[:id])
  erb :show_student, :layout => :layout2
end

#Edit a individual student
get '/students/:id/edit' do
  redirect to('/logout') unless session[:admin]
  @student = Student.get(params[:id])
  erb :edit_student, :layout => :layout2
end

#Create new student
post '/students' do
  redirect to('/logout') unless session[:admin]
  @student = Student.create(params[:student])
  redirect to('/students')
end

#Edits a single student
put '/students/:id' do
  redirect to('/logout') unless session[:admin]
  @student = Student.get(params[:id])
  @student.update(params[:student])
  redirect to("/students/#{@student.id}")
end

#Deletes a single student
delete '/students/:id' do
  redirect to('/logout') unless session[:admin]
  Student.get(params[:id]).destroy
  redirect to('/students')
end
