# frozen_string_literal: true

module SpritWatch
  # TODO: Presenter is probably a better name
  module Formatter
    class << self
      def formats
        constants.map { |symbol| symbol.to_s.downcase }
      end

      def formatter(format)
        const_get(format.capitalize.to_s).new
      end
    end

    class Long
      def format(station)
        "#{station.id} #{station}: #{station.price(:diesel)}"
      end
    end

    class Short
      def format(station)
        "#{station}: #{station.price(:diesel)}"
      end
    end
  end
end
