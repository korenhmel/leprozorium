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

    # создает таблицу если таблица не существует
    @db.execute 'CREATE  TABLE IF NOT EXISTS Comments
 (
id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL ,
 created_date DATETIME,
 content TEXT,
 post_id integer)'

    @db.execute 'CREATE  TABLE IF NOT EXISTS Users
 (
id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL ,
 created_date DATETIME,
 username TEXT,
 password TEXT)'

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

   #выбираем комментарии для нашего поста
   @comments  = @db.execute 'select * from Comments where post_id = ? order by id', [post_id]

  # возвращаем представление details.erb
  erb :details
    #example1
   # erb "Displaing information for post with id: #{post_id}"


end
# обработчик пост запроса /details/...
# (браузер отправляет данные на сервер, мы их принимаем)
post '/details/:fuckid' do
  post_id = params[:fuckid]

  name =  params[:post]
  @db.execute 'insert into Comments
    (
     content,
     created_date,
     post_id
    )
      values
    (
      ?,
      datetime(),
      ?
    )', [name, post_id]

  # перенаправляем на главную страницу поста
  redirect to('/details/'+ post_id)

  # erb "You typed comments #{name} for post #{post_id}"
end

get '/user' do
  erb :user_registration
end

post '/user' do
  username = params['username']
  password = params['password']
  hh = { username: 'your name', password: 'your password'}
  @error ="Enter #{hh.select { |key, value| params[key] == "" }.values.join(", ")}"
  if @error != ""
   @initials = "You successily registered!!"
  end
  @db.execute 'insert into Users
    (
     username,
     password,
     created_date
    )
      values
    (
      ?,
      ?,
      datetime()
    )', [username, password]
  erb :user_registration
end