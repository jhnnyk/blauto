class FillupController < ApplicationController

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
    @fillup = Fillup.create(:mileage  => mileage,
                            :gallons  => gallons,
                            :octane   => octane,
                            :price    => price,
                            :brand    => brand,
                            :location => location,
                            :car_id   => @car.id)
    @fillup.fillup_date = Time.now
    @fillup.save

    redirect to "/cars/#{@car.id}"
  end

  get '/fillups/:id' do
    if logged_in?
      @fillup = Fillup.find_by(:id => params[:id])
      erb :'fillups/show'
    else
      redirect to '/login'
    end
  end

  get '/fillups/:id/edit' do
    if logged_in?
      @fillup = Fillup.find_by(:id => params[:id])
      erb :'fillups/edit'
    else
      redirect to '/login'
    end
  end

  patch '/fillups/:id' do
    @fillup = Fillup.find_by(:id => params[:id])

    @fillup.mileage  = Sanitize.fragment(params[:mileage])
    @fillup.gallons  = Sanitize.fragment(params[:gallons])
    @fillup.octane   = params[:octane]
    @fillup.price    = Sanitize.fragment(params[:price])
    @fillup.brand    = Sanitize.fragment(params[:brand])
    @fillup.location = Sanitize.fragment(params[:location])
    @fillup.save

    redirect to "/cars/#{@fillup.car.id}"
  end

  delete '/fillups/:id/delete' do
    @fillup = Fillup.find_by(:id => params[:id])
    car = @fillup.car

    if current_user == @fillup.car.user
      @fillup.delete
    end

    redirect to "/cars/#{car.id}"
  end

end
