#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sqlite3'
# require "sinatra/reloader"
def init_db
  @db = SQLite3::Database.new 'leprozorium.db'
  @db.results_as_hash = true
end
# before вызывается каждый раз при перезагрузке любой страницы
before do
  # инициализация базы данных
  init_db
end
# configure вызывается каждый раз при конфигурации приложения:
# когда изменился код программы И перезагрузилась страница
configure do
  # инициализация базы данных
    init_db
    # создает таблицу если таблица не существует
  @db.execute 'CREATE  TABLE IF NOT EXISTS Posts
 (
id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL ,
 created_date DATETIME,
 content TEXT)'
end

get '/' do
  @results = @db.execute 'select * from Posts order by id desc'
	erb :index
end
# обработчик get- запроса
#(браузер получает таблицу с сервера)
get '/new' do
  erb :new
end

# обработчик post- запроса
#(браузер отправляет данные на сервер)
post '/new' do
  # получаем переменную из post- запроса
name =  params[:post]
  if name.length <= 0
    @error = 'type post text'
   return erb :new
  end
# сохранение данных в БД
@db.execute 'insert into Posts (content, created_date) values (?, datetime())', [name]

   redirect to '/'
  # erb name
end

# вывод информации о посте
get '/details/:fuckid' do

  # получаем переменную из url'a
  post_id = params[:fuckid]

  #example2
  # получаем список постов
  # (у нас только один пост)
  results = @db.execute 'select * from Posts where id = ?', [post_id]
  # выбираем этот один пост в переменную @row
   @row = results[0]
  # возвращаем представление details.erb
  erb :details
    #example1
   # erb "Displaing information for post with id: #{post_id}"


end