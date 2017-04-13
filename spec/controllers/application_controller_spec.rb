require 'spec_helper'

describe ApplicationController do

  describe "Homepage" do
    it "loads the homepage" do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome to Blauto")
    end
  end


  describe "Signup Page" do

    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'signup directs user to cars index' do
      params = {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include("/cars")
    end

    it 'does not let a user sign up without a username' do
      params = {
        :username => "",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without an email' do
      params = {
        :username => "skittles123",
        :email => "",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without a password' do
      params = {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => ""
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a logged in user view the signup page' do
      user = User.create(:username => "skittles123", :email => "skittles@aol.com", :password => "rainbows")
      params = {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      post '/signup', params
      session = {}
      session[:id] = user.id
      get '/signup'
      expect(last_response.location).to include('/cars')
    end
  end

  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads the tweets index after login' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome,")
    end

    it 'does not let user view login page if already logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      session = {}
      session[:id] = user.id
      get '/login'
      expect(last_response.location).to include("/cars")
    end
  end

  describe "logout" do
    it "lets a user logout if they are already logged in" do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/login")
    end

    it 'does not let a user logout if not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")
    end

    it 'does not load /cars if user not logged in' do
      get '/cars'
      expect(last_response.location).to include("/login")
    end

    it 'does load /cars if user is logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'Login'
      expect(page.current_path).to eq('/cars')
    end
  end

  describe 'user show page' do
    it 'shows all a single users cars' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      car1 = Car.create(:year => 2000, :car_make => "Toyota", :car_model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user.id)
      car2 = Car.create(:year => 2013, :car_make => "Subaru", :car_model => "Outback", :nickname => "Subie", :mileage => 122000, :user_id => user.id)
      get "/users/#{user.slug}"

      expect(last_response.body).to include("Land Cruiser")
      expect(last_response.body).to include("Outback")
    end
  end

  describe 'new action' do
    context 'logged in' do
      it 'lets user view new car form if logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'Login'
        visit '/cars/new'
        expect(page.status_code).to eq(200)

      end

      it 'lets user create a car if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'Login'

        visit '/cars/new'
        fill_in(:year, :with => 2000)
        fill_in(:car_make, :with => "Toyota")
        fill_in(:car_model, :with => "Land Cruiser")
        fill_in(:nickname, :with => "Land Cruisy")
        fill_in(:mileage, :with => 1999)
        click_button 'Add car'

        user = User.find_by(:username => "becky567")
        car = Car.find_by(:nickname => "Land Cruisy")
        expect(car).to be_instance_of(Car)
        expect(car.user_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user create a car for another user' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'Login'

        visit '/cars/new'

        fill_in(:year, :with => 2000)
        fill_in(:car_make, :with => "Toyota")
        fill_in(:car_model, :with => "Land Cruiser")
        fill_in(:nickname, :with => "Land Cruisy")
        fill_in(:mileage, :with => 1999)
        click_button 'Add car'

        user = User.find_by(:id=> user.id)
        user2 = User.find_by(:id => user2.id)
        car = Car.find_by(:nickname => "Land Cruisy")
        expect(car).to be_instance_of(Car)
        expect(car.user_id).to eq(user.id)
        expect(car.user_id).not_to eq(user2.id)
      end

      it 'does not let a user create a car without a nickname' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'Login'

        visit '/cars/new'

        fill_in(:nickname, :with => "")
        click_button 'Add car'

        expect(Car.find_by(:nickname => "")).to eq(nil)
        expect(page.current_path).to eq("/cars/new")
      end
    end

    context 'logged out' do
      it 'does not let user view new car form if not logged in' do
        get '/cars/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

end
