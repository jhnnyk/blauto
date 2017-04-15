require 'spec_helper'

describe ServiceController do

  describe 'new service' do
    context 'logged in' do
      it 'lets user view new service form if logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        car = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'Login'

        visit "/cars/#{car.id}/serivices/new"
        expect(page.status_code).to eq(200)
      end

      it 'lets user create a service if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        car = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'Login'

        visit "/cars/#{car.id}/services/new"

        fill_in(:mileage, :with => 1999)
        fill_in(:items, :with => "oil change, front brakes")
        fill_in(:price, :with => 320.22)
        click_button 'Add service'

        expect(page.body).to include("oil change, front brakes")
      end
    end

    context 'logged out' do
      it 'does not let user view new service form if not logged in' do
        get '/cars/1/services/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'show action' do
    context 'logged in' do
      it 'displays a single service' do

        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        car = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user.id)
        car_service = Service.create(:mileage => 215000, :items => "oil change, front brakes", :price => 369.00, :shop => "Stevinson Toyota", :location => "Golden, CO", :car_id => car.id, :service_date => Time.now)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'Login'

        visit "/services/#{service.id}"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("delete")
        expect(page.body).to include(car_service.shop)
        expect(page.body).to include("mode_edit")
      end
    end

    context 'logged out' do
      it 'does not let a user view a service' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        car = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user.id)
        car_service = Service.create(:mileage => 215000, :items => "oil change, front brakes", :price => 369.00, :shop => "Stevinson Toyota", :location => "Golden, CO", :car_id => car.id, :service_date => Time.now)

        get "/services/#{car_service.id}"
        expect(last_response.location).to include("/login")
      end
    end

  end

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view service edit form if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        car = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user.id)
        car_service = Service.create(:mileage => 215000, :items => "oil change, front brakes", :price => 369.00, :shop => "Stevinson Toyota", :location => "Golden, CO", :car_id => car.id, :service_date => Time.now)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'Login'
        visit "/services/#{car_service.id}/edit"
        expect(page.status_code).to eq(200)
        expect(page.body).to include(car_service.location)
      end

      it 'lets a user edit their own service if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        car = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user.id)
        car_service = Service.create(:mileage => 215000, :items => "oil change, front brakes", :price => 369.00, :shop => "Stevinson Toyota", :location => "Golden, CO", :car_id => car.id, :service_date => Time.now)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'Login'
        visit "/services/#{car_service.id}/edit"

        fill_in(:location, :with => "Idaho Springs, CO")

        click_button 'Edit fill up'
        expect(Service.find_by(:location => "Lakewood, CO")).to be_instance_of(Service)
        expect(Service.find_by(:location => "Evergreen, CO")).to eq(nil)

        expect(page.status_code).to eq(200)
      end

    end

    context "logged out" do
      it 'does not load let user view service edit form if not logged in' do
        get '/services/1/edit'
        expect(last_response.location).to include("/login")
      end
    end

  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete their own service if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        car = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user.id)
        car_service = Service.create(:mileage => 215000, :items => "oil change, front brakes", :price => 369.00, :shop => "Stevinson Toyota", :location => "Golden, CO", :car_id => car.id, :service_date => Time.now)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'Login'
        visit "/services/#{car_service.id}"

        click_button "delete"
        expect(page.status_code).to eq(200)
        expect(Service.find_by(:location => "Evergreen, CO")).to eq(nil)
      end

      it 'does not let a user delete a service they do not own' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        car1 = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user1.id)
        car_service = Service.create(:mileage => 215000, :items => "oil change, front brakes", :price => 369.00, :shop => "Stevinson Toyota", :location => "Golden, CO", :car_id => car1.id, :service_date => Time.now)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        car2 = Car.create(:year => 2001, :car_make => "Subaru", :car_model => "Outback", :nickname => "Subie", :mileage => 122000, :user_id => user2.id)
        car_service2 = Service.create(:mileage => 215000, :items => "oil change, front brakes", :price => 369.00, :shop => "Oldes Garage", :location => "Evergreen, CO", :car_id => car2.id, :service_date => Time.now)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'Login'
        visit "/services/#{car_service2.id}"
        click_button "delete"
        expect(page.status_code).to eq(200)
        expect(Service.find_by(:location => "Evergreen, CO")).to be_instance_of(Service)
        expect(page.current_path).to include('/users/becky567')
      end

    end

    context "logged out" do
      it 'does not load let user delete a service if not logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        car = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user.id)
        car_service = Service.create(:mileage => 215000, :items => "oil change, front brakes", :price => 369.00, :shop => "Stevinson Toyota", :location => "Golden, CO", :car_id => car.id, :service_date => Time.now)
        visit '/services/1'
        expect(page.current_path).to eq("/login")
      end
    end

  end

end
