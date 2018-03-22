# frozen_string_literal: true

require 'sprit_watch/station'
require 'sprit_watch/fuel_price'

module SpritWatch
  class StationMapper
    def map(attributes)
      Station.new.tap do |station|
        station.id = attributes['id'].strip
        station.brand = attributes['brand'].strip
        station.street = [attributes['street'], attributes['houseNumber']].join(' ').strip
        station.city = attributes['place'].strip
        station.price = FuelPrice.new(:diesel, attributes['diesel'])
        station.closed = !attributes['isOpen']
      end
    end
  end
end
