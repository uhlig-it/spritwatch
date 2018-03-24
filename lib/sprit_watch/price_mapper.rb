# frozen_string_literal: true

module SpritWatch
  class PriceMapper
    def map(id, attributes)
      Station.new.tap do |station|
        station.id = id

        if attributes['status'] != 'no prices'
          station.closed = attributes['status'] != 'open'
          station.price = FuelPrice.new(:diesel, attributes['diesel'])
        end
      end
    end
  end
end
