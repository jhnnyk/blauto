require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "blauto_secret"
  end

  helpers do

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    @user = User.find_by(id: session[:user_id])
  end

end

  get '/' do
    erb :index
  end

  get '/signup' do
    erb :'users/signup'
  end

  post '/signup' do
    @user = User.new(username: params[:username],
                        email: params[:email],
                     password: params[:password])

    if @user.save
      session[:user_id] = @user.id
      redirect to '/cars'
    else
      redirect to '/signup'
    end
  end

end
