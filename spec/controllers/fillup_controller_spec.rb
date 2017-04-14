require 'spec_helper'

describe FillupController do

  describe 'new fillup' do
    context 'logged in' do
      it 'lets user view new fillup form if logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        car = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'Login'

        visit "/cars/#{car.id}/fillups/new"
        expect(page.status_code).to eq(200)
      end

      it 'lets user create a fillup if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        car = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'Login'

        visit "/cars/#{car.id}/fillups/new"

        fill_in(:mileage, :with => 1999)
        fill_in(:gallons, :with => 21.158)
        fill_in(:price, :with => 60.22)
        click_button 'Add fill up'

        expect(page.body).to include("21.158")
      end
    end

    context 'logged out' do
      it 'does not let user view new fillup form if not logged in' do
        get '/cars/1/fillups/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'show action' do
    context 'logged in' do
      it 'displays a single fillup' do

        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        car = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user.id)
        fillup = Fillup.create(:mileage => 215000, :gallons => 12, :octane => "91", :price => 36.00, :brand => "Chevron", :location => "Evergreen, CO", :car_id => car.id, :fillup_date => Time.now)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'Login'

        visit "/fillups/#{fillup.id}"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("delete")
        expect(page.body).to include(fillup.location)
        expect(page.body).to include("mode_edit")
      end
    end

    context 'logged out' do
      it 'does not let a user view a fillup' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        car = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user.id)
        fillup = Fillup.create(:mileage => 215000, :gallons => 12, :octane => "91", :price => 36.00, :brand => "Chevron", :location => "Evergreen, CO", :car_id => car.id, :fillup_date => Time.now)

        get "/fillups/#{fillup.id}"
        expect(last_response.location).to include("/login")
      end
    end

  end
end
