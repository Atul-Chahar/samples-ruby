require 'sinatra'
require 'sinatra/json'
require 'json'
require 'pg'

# Configure Sinatra
set :bind, '0.0.0.0'
set :port, 4567

# Database connection helper
def get_db_connection
  PG.connect(
    host: ENV['DATABASE_HOST'] || 'localhost',
    port: ENV['DATABASE_PORT'] || 5432,
    dbname: ENV['DATABASE_NAME'] || 'keploy_demo',
    user: ENV['DATABASE_USER'] || 'postgres',
    password: ENV['DATABASE_PASSWORD'] || 'postgres'
  )
end

# Initialize database on startup
def init_db
  conn = get_db_connection
  conn.exec(<<-SQL)
    CREATE TABLE IF NOT EXISTS users (
      id SERIAL PRIMARY KEY,
      name VARCHAR(255) NOT NULL,
      email VARCHAR(255) UNIQUE NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  SQL
  conn.close
end

# Run initialization
init_db

# Health check
get '/' do
  json message: 'Welcome to Keploy Ruby Quickstart!'
end

# Create a user
post '/users' do
  request.body.rewind
  data = JSON.parse(request.body.read)
  
  conn = get_db_connection
  result = conn.exec_params(
    'INSERT INTO users (name, email) VALUES ($1, $2) RETURNING id, name, email, created_at',
    [data['name'], data['email']]
  )
  user = result[0]
  conn.close
  
  status 201
  json id: user['id'].to_i, name: user['name'], email: user['email'], created_at: user['created_at']
end

# Get all users
get '/users' do
  conn = get_db_connection
  result = conn.exec('SELECT id, name, email FROM users ORDER BY id')
  users = result.map { |row| { id: row['id'].to_i, name: row['name'], email: row['email'] } }
  conn.close
  
  json users
end

# Get user by ID
get '/users/:id' do
  conn = get_db_connection
  result = conn.exec_params('SELECT id, name, email, created_at FROM users WHERE id = $1', [params[:id]])
  conn.close
  
  if result.ntuples > 0
    user = result[0]
    json id: user['id'].to_i, name: user['name'], email: user['email'], created_at: user['created_at']
  else
    status 404
    json error: 'User not found'
  end
end

# Delete user
delete '/users/:id' do
  conn = get_db_connection
  result = conn.exec_params('DELETE FROM users WHERE id = $1 RETURNING id', [params[:id]])
  conn.close
  
  if result.ntuples > 0
    json message: 'User deleted successfully'
  else
    status 404
    json error: 'User not found'
  end
end
