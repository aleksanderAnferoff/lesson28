#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


def init_db
	@db = SQLite3::Database.new 'lesson28.db'
	@db.results_as_hash = true
end

before do
	init_db
end

configure do
	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts 
				(id integer PRIMARY KEY AUTOINCREMENT,
				"created_date" date,
				content text)'
end

get '/' do
	erb "Yoo!"			
end

get '/new' do
  erb :new 
end

post '/new' do
	content = params[:content]
	erb "You typed: #{content}"

	if content.length <= 0
		@error = 'Введите текст'
		return erb :new
	end
end