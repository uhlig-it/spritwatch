# frozen_string_literal: true

module SpritWatch
  class FuelPrice
    attr_reader :type, :euros

    def initialize(type, euros)
      @type = type
      @euros = euros
    end

    def to_s
      "#{@type.to_s.capitalize}: #{@euros} €"
    end
  end
end
