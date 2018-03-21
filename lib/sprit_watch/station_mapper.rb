# frozen_string_literal: true

require 'sprit_watch/station'
require 'sprit_watch/fuel_price'

module SpritWatch
  class StationMapper
    def map(attributes)
      Station.new.tap do |station|
        station.id = attributes['id']
        station.brand = attributes['brand']
        station.price = FuelPrice.new(:diesel, attributes['diesel'])
      end
    end
  end
end
