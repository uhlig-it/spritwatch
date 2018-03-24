# frozen_string_literal: true

require 'sprit_watch/fuel_price_factory'

module SpritWatch
  class PriceMapper
    def initialize
      @fuel_price_factory = FuelPriceFactory.new
    end

    def map(id, attributes)
      Station.new.tap do |station|
        station.id = id

        if attributes['status'] != 'no prices'
          station.closed = attributes['status'] != 'open'

          TYPES.each do |type|
            station.price = @fuel_price_factory.produce(type, attributes[type.to_s], '€')
          end
        end
      end
    end
  end
end
