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

  get '/error' do
    erb :error
  end

  post '/login' do
    if User.find_by(username: params[:username], password: params[:password])
      current_user = User.find_by(username: params[:username], password: params[:password])
      session[:user_id] = current_user.id
      redirect '/account'
    else
#      redirect '/error' This is not passing the tests so I used erb :error
      erb :error
    end
  end

  get '/account' do
    if Helpers.is_logged_in?(session)
      @current_user = Helpers.current_user(session)
      erb :account
    else
#      redirect '/error' This is not working so I used erb :error
      erb :error
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end



  post '/logout' do
    session.clear
    redirect '/logout'
  end

end
