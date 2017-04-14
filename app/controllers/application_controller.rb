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
    if logged_in?
      redirect to '/cars'
    else
      erb :'users/signup'
    end
  end

  post '/signup' do
    username = Sanitize.fragment(params[:username])
    email    = Sanitize.fragment(params[:email])
    password = Sanitize.fragment(params[:password])

    @user = User.new(username: username,
                        email: email,
                     password: password)

    if @user.save
      session[:user_id] = @user.id
      redirect to '/cars'
    else
      redirect to '/signup'
    end
  end

  get '/login' do
    if logged_in?
      redirect to '/cars'
    else
      erb :'users/login'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      # TODO: add flash message for successful login
      session[:user_id] = @user.id
      redirect to '/cars'
    else
      # TODO: add flash message for unsucessful login
      redirect to '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect to '/login'
  end

  get '/cars' do
    if logged_in?
      erb :'cars/index'
    else
      redirect to '/login'
    end
  end

  get '/cars/new' do
    if logged_in?
      erb :'cars/new'
    else
      redirect to '/login'
    end
  end

  post '/cars' do
    year      = Sanitize.fragment(params[:year])
    car_make  = Sanitize.fragment(params[:car_make])
    car_model = Sanitize.fragment(params[:car_model])
    nickname  = Sanitize.fragment(params[:nickname])
    mileage   = Sanitize.fragment(params[:mileage])

    @car = Car.create(:year      => year,
                      :car_make  => car_make,
                      :car_model => car_model,
                      :nickname  => nickname,
                      :mileage   => mileage)
    @car.user = current_user

    if @car.save
      redirect to "/users/#{current_user.slug}"
    else
      redirect to '/cars/new'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

  get '/cars/:id' do
    @car = Car.find_by(:id => params[:id])
    erb :'cars/show'
  end

  get '/cars/:id/fillups/new' do
    if logged_in?
      @car = Car.find_by(:id => params[:id])
      erb :'fillups/new'
    else
      redirect to '/login'
    end
  end

  post '/fillups/:id' do
    mileage  = Sanitize.fragment(params[:mileage])
    gallons  = Sanitize.fragment(params[:gallons])
    octane   = Sanitize.fragment(params[:octane])
    price    = Sanitize.fragment(params[:price])
    brand    = Sanitize.fragment(params[:brand])
    location = Sanitize.fragment(params[:location])

    @car = Car.find_by(:id => params[:id])
    @fillup = Fillup.create(:mileage => mileage,
                            :gallons => gallons,
                            :octane  => octane,
                            :price   => price,
                            :car_id  => @car.id)
    @fillup.fillup_date = Time.now
    @fillup.save

    redirect to "/cars/#{@car.id}"
  end

end
