require_relative '../../config/environment'
class ApplicationController < Sinatra::Base
  configure do
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  post '/login' do
    binding.pry
    if User.find_by(username: params[:username], password: params[:password])
      current_user = User.find_by(username: params[:username], password: params[:password])
      session[:user_id] = current_user.id
      redirect '/account'
    else
      redirect '/error'
    end
  end

  get '/account' do
    if Helpers.is_logged_in?
      @current_user = Helpers.current_user
      erb :account
    else
      redirect '/error'
    end

  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/error' do
    erb :error
  end

  post '/logout' do
    session.clear
    redirect '/logout'
  end

end
