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
	@results = @db.execute 'select * from Posts order by id desc'
	
	erb :index
end

get '/new' do
  erb :new 
end

post '/new' do
	#получаем переменную из пост-запросов
	content = params[:content]

	if content.length <= 0
		@error = 'Введите текст'
		return erb :new
	end
	
	#сохранение данных в БД
	@db.execute 'insert into Posts (content, created_date) values (?, datetime())',[content]

	#перенаправление на главную страницу
	redirect to '/'
end

get '/details/:post_id' do

	# получаем переменную из url
	post_id = params[:post_id]

	#получаем список постов (один)
	results = @db.execute 'select * from Posts where id=?',[post_id]
	#выбираем этот один пост в переменную @row
	@row = results[0]

	erb :details
end