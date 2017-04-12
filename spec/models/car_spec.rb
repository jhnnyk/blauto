require 'spec_helper'

describe 'Car' do
  before do
    user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
    @car = Car.create(:year => 2000, :make => "Toyota", :model => "Land Cruiser", :nickname => "Land Cruiser", :mileage => 318150, :user_id => user.id)
  end

  it 'can slug its nickname' do
    expect(@car.slug).to eq("land-cruiser")
  end

  it 'can find a car based on the slug' do
    slug = @car.slug
    expect(Car.find_by_slug(slug).model).to eq("Land Cruiser")
  end
end
