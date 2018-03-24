# frozen_string_literal: true

require 'sprit_watch/fuel_price'
require 'sprit_watch/price'

module SpritWatch
  class FuelPriceFactory
    def produce(type, amount, currency)
      FuelPrice.new(type, Price.new(amount, currency))
    end
  end
end
