class Car < ActiveRecord::Base
  belongs_to :user

  def slug
    self.nickname.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    Car.all.find{ |car| car.slug == slug }
  end

end
