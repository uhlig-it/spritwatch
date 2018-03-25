# frozen_string_literal: true

require 'sprit_watch/station_registry'

module SpritWatch
  class PricePresenter
    attr_reader :station_registry

    def initialize(station_registry)
      @station_registry = station_registry
    end

    def find(types)
      case types.size
      when 0
        Null.new
      when 1
        Single.new(station_registry, types.first)
      else
        Multi.new(station_registry, types)
      end
    end

    class Null
      def present(*)
        warn 'Warning: Evaluation of preferred types and command-line switches yields an empty list'
      end
    end

    class Single < PricePresenter
      attr_reader :type

      def initialize(station_registry, type)
        super(station_registry)
        @type = type
      end

      def present(stations, prefix = '')
        warn "#{type.to_s.capitalize} prices as of #{Time.now}:"

        sorted(stations).each do |station|
          price = station.price(type.to_sym).price
          puts "#{prefix}#{lookup_station_name(station)}: #{price}"
        end
      end

      private

      def lookup_station_name(station)
        station_registry.lookup(station.id)
      end

      def sorted(stations)
        stations.sort { |a, b| a.price(type) <=> b.price(type) }
      end
    end

    class Multi < PricePresenter
      attr_reader :types

      def initialize(station_registry, types)
        super(station_registry)
        @types = types
      end

      def present(stations)
        types.each do |type|
          Single.new(station_registry, type).present(stations, '  ')
        end
      end
    end
  end
end
