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

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view fillup edit form if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        car = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user.id)
        fillup = Fillup.create(:mileage => 215000, :gallons => 12, :octane => "91", :price => 36.00, :brand => "Chevron", :location => "Evergreen, CO", :car_id => car.id, :fillup_date => Time.now)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'Login'
        visit "/fillups/#{fillup.id}/edit"
        expect(page.status_code).to eq(200)
        expect(page.body).to include(fillup.location)
      end

      it 'lets a user edit their own fillup if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        car = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user.id)
        fillup = Fillup.create(:mileage => 215000, :gallons => 12, :octane => "91", :price => 36.00, :brand => "Chevron", :location => "Evergreen, CO", :car_id => car.id, :fillup_date => Time.now)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'Login'
        visit "/fillups/#{fillup.id}/edit"

        fill_in(:location, :with => "Idaho Springs, CO")

        click_button 'Edit fill up'
        expect(Fillup.find_by(:location => "Idaho Springs, CO")).to be_instance_of(Fillup)
        expect(Fillup.find_by(:location => "Evergreen, CO")).to eq(nil)

        expect(page.status_code).to eq(200)
      end

    end

    context "logged out" do
      it 'does not load let user view fillup edit form if not logged in' do
        get '/fillups/1/edit'
        expect(last_response.location).to include("/login")
      end
    end

  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete their own fillup if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        car = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user.id)
        fillup = Fillup.create(:mileage => 215000, :gallons => 12, :octane => "91", :price => 36.00, :brand => "Chevron", :location => "Evergreen, CO", :car_id => car.id, :fillup_date => Time.now)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'Login'
        visit "/fillups/#{fillup.id}"

        click_button "delete"
        expect(page.status_code).to eq(200)
        expect(Fillup.find_by(:location => "Evergreen, CO")).to eq(nil)
      end

      it 'does not let a user delete a fillup they do not own' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        car1 = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user1.id)
        fillup1 = Fillup.create(:mileage => 215000, :gallons => 12, :octane => "91", :price => 36.00, :brand => "Chevron", :location => "Evergreen, CO", :car_id => car1.id, :fillup_date => Time.now)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        car2 = Car.create(:year => 2001, :car_make => "Subaru", :car_model => "Outback", :nickname => "Subie", :mileage => 122000, :user_id => user2.id)
        fillup2 = Fillup.create(:mileage => 122001, :gallons => 14, :octane => "85", :price => 48.00, :brand => "Chevron", :location => "Conifer, CO", :car_id => car2.id, :fillup_date => Time.now)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'Login'
        visit "/fillups/#{fillup2.id}"
        click_button "delete"
        expect(page.status_code).to eq(200)
        expect(Fillup.find_by(:location => "Conifer, CO")).to be_instance_of(Fillup)
        expect(page.current_path).to include("/cars/#{car2.id}")
      end

    end

    context "logged out" do
      it 'does not load let user delete a fillup if not logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        car = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user.id)
        fillup = Fillup.create(:mileage => 215000, :gallons => 12, :octane => "91", :price => 36.00, :brand => "Chevron", :location => "Evergreen, CO", :car_id => car.id, :fillup_date => Time.now)
        visit '/fillups/1'
        expect(page.current_path).to eq("/login")
      end
    end

  end

end
