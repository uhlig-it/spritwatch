# frozen_string_literal: true

module SpritWatch
  class FuelPrice
    attr_reader :type, :euros

    def initialize(type, euros)
      @type = type
      @euros = euros
    end
  end
end
