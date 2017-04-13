class Car < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :nickname

  def slug
    self.nickname.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    Car.all.find{ |car| car.slug == slug }
  end

end
