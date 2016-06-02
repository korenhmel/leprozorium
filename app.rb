#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sqlite3'
# require "sinatra/reloader"
def init_db
  @db = SQLite3::Database.new 'leprozorium.db'
  @db.results_as_hash = true
end
configure do
    init_db
  @db.execute 'CREATE  TABLE IF NOT EXISTS Posts
 (
id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL ,
 created_date DATETIME,
 content TEXT)'
end

get '/' do
	erb "Hello!!!! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School!!!</a>"
end

get '/new' do
  erb :new
end

post '/new' do
name =  params[:post]
  erb name
end