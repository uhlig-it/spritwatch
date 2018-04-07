# frozen_string_literal: true

require 'sprit_watch/station'
require 'sprit_watch/fuel_price_factory'

module SpritWatch
  #
  # Maps each result of a list query to a station. The attributes
  # are slightly different from a price query, so that we need a separate mapper
  # class.
  #
  class StationListMapper
    def initialize
      @fuel_price_factory = FuelPriceFactory.new
    end

    def map(attributes)
      Station.new.tap do |station|
        station.id = attributes['id'].strip
        station.brand = attributes['brand'].strip
        station.street = street(attributes)
        station.city = attributes['place'].strip
        station.closed = !attributes['isOpen']
        assign_prices(station, attributes)
      end
    end

    private

    def assign_prices(station, attributes)
      TYPES.each do |type|
        station.price = @fuel_price_factory.produce(type, attributes[type.to_s], '€')
      end
    end

    def street(attributes)
      [
        attributes['street'].strip,
        attributes['houseNumber'].strip
      ].join(' ').strip
    end
  end
end
