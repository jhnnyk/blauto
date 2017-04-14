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
    @fillup = Fillup.create(:mileage => mileage,
                            :gallons => gallons,
                            :octane  => octane,
                            :price   => price,
                            :car_id  => @car.id)
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
end
