# frozen_string_literal: true

require 'sprit_watch/station'
require 'sprit_watch/fuel_price'

module SpritWatch
  class StationMapper
    def map(attributes)
      Station.new.tap do |station|
        station.id = attributes['id']
        station.brand = attributes['brand']
        station.street = attributes['street']
        station.price = FuelPrice.new(:diesel, attributes['diesel'])
        station.closed = !attributes['isOpen']
      end
    end
  end
end
