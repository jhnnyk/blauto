class ServiceController < ApplicationController

  get '/cars/:id/services/new' do
    if logged_in?
      @car = Car.find_by(:id => params[:id])
      erb :'services/new'
    else
      redirect to '/login'
    end
  end

  post '/services/:id' do
    mileage  = Sanitize.fragment(params[:mileage])
    items    = Sanitize.fragment(params[:items])
    price    = Sanitize.fragment(params[:price])
    shop     = Sanitize.fragment(params[:shop])
    location = Sanitize.fragment(params[:location])

    @car = Car.find_by(:id => params[:id])
    @service = Service.create(:mileage  => mileage,
                            :items    => items,
                            :price    => price,
                            :shop     => shop,
                            :location => location,
                            :car_id   => @car.id)
    @service.service_date = Time.now
    @service.save

    redirect to "/cars/#{@car.id}"
  end

  get '/services/:id' do
    if logged_in?
      @service = Service.find_by(:id => params[:id])
      erb :'services/show'
    else
      redirect to '/login'
    end
  end

  get '/services/:id/edit' do
    if logged_in?
      @service = Service.find_by(:id => params[:id])
      erb :'services/edit'
    else
      redirect to '/login'
    end
  end

  patch '/services/:id' do
    @service = Service.find_by(:id => params[:id])

    @service.mileage  = Sanitize.fragment(params[:mileage])
    @service.items  = Sanitize.fragment(params[:items])
    @service.price    = Sanitize.fragment(params[:price])
    @service.shop    = Sanitize.fragment(params[:shop])
    @service.location = Sanitize.fragment(params[:location])
    @service.save

    redirect to "/services/#{@service.id}"
  end

  delete '/services/:id/delete' do
    @service = Service.find_by(:id => params[:id])

    if current_user == @service.car.user
      @service.delete
    end

    redirect to "/users/#{current_user.slug}"
  end

end
