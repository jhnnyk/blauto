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

end
