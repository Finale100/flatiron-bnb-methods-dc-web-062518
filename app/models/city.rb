require 'pry'
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date1, date2)
    available = []
    check = true
    arr = Listing.all.select do |listing|
      listing.neighborhood.city.name == self.name
    end
    arr.each do |listing|
      listing.reservations.each do |reservation|
        c_in = reservation.checkin
        c_out = reservation.checkout
        d1 = Date.parse(date1)
        d2 = Date.parse(date2)
        if [d1, c_in].max < [d2, c_out].min
          check = false
        end
      end
      if check == true
        available << listing
      else
      check = true
      end
    end
    available
  end

  def self.highest_ratio_res_to_listings
    number_reservations = 0
    number_listings = 0
    ratio = 0
    counter = 0
    city2 = nil
    City.all.each do |city|
        number_listings = city.listings.count
      city.listings.each do |listing|
        number_reservations += listing.reservations.count
      end
      ratio = number_reservations / number_listings
      if counter < ratio
        counter = ratio
        city2 = city
      end
      number_reservations = 0
    end
    city2
  end

    def self.most_res
      city2 = nil
      number_reservations = 0
      counter = 0
      City.all.each do |city|
        city.listings.each do |listing|
          number_reservations += listing.reservations.count
        end
        if counter < number_reservations
          counter = number_reservations
          city2 = city
        end
        number_reservations = 0
      end
      city2
    end
end
