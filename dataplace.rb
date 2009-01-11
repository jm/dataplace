require 'rubygems'
require 'sinatra'
require 'sinatra_ext'

require 'data_objects'
require 'do_ext'

enable :sessions

before do
  @drivers = DataObjects::Connection.drivers
  @user = request.cookies['user']
  @database = request.cookies['database']
  @host = request.cookies['host']
  
  if @database
    @connection = DataObjects::Connection.new(request.cookies['url'])
    @table_count = @connection.create_command("SHOW TABLES;").execute_non_query.affected_rows
    @comment = "#{@table_count} tables"
  end
end

get '/' do
  # Inquire about connection information  
  erb :main
end

post '/databases' do
  # TODO: Sanitize driver values, check other values
  user = params['user'] ? "#{params['user']}:#{params['password']}@" : ""
  socket = port = nil
  
  if params['socket'] =~ /^\d+$/
    port = ":#{params['socket']}"
  else
    socket = "?socket=#{params['socket']}"
  end
  
  url = "#{params['driver']}://#{user}@#{params['host']}#{port || socket}"
  
  set_cookie("driver", params['driver'])
  set_cookie("user", params['user'])
  set_cookie("credentials", user)
  set_cookie("host", params['host'])
  set_cookie("connection", (port ? "port" : "socket"))
  set_cookie("connector", (port || socket))
  
  @databases = eval("DataObjects::#{params['driver'].capitalize}::Connection").databases(url)
  @databases.map! do |db|
    c = DataObjects::Connection.new("#{params['driver']}://#{user}#{params['host']}#{port}/#{db}#{socket}")
    table_count = c.create_command("SHOW TABLES;").execute_non_query.affected_rows
    c.close
    c.dispose
    
    [db, table_count]
  end
  
  erb :databases
end

get '/databases/:database' do
  # Show tables
  url = "#{request.cookies['driver']}://#{request.cookies['credentials']}#{request.cookies['host']}#{request.cookies['connector'] if request.cookies['connection'] == 'port'}/#{params[:database]}#{request.cookies['connector'] if request.cookies['connection'] == 'socket'}"
  set_cookie("database", params[:database])
  set_cookie("url", url)
  
  @table_reader = @connection.create_command("SHOW TABLE STATUS FROM #{params[:database]};").execute_reader
  
  erb :database
end

get '/databases/:database/tables/:table' do
  
end

get '/databases/:database/tables/new' do
  
end

get '/databases/:database/tables' do
  
end

post '/databases/:database/tables' do
  
end

get '/databases/:database/tables/:table/edit' do

end

put '/databases/:database/tables/:table' do
  
end