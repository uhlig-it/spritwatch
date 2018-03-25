# frozen_string_literal: true

module SpritWatch
  class PricePresenter
    def self.find(preferred_types)
      case preferred_types.size
      when 0
        Null.new
      when 1
        type = preferred_types.first
        Single.new(type)
      else
        Multi.new(preferred_types)
      end
    end

    # TODO: This may fail; we may need to look it up via #details or use a NullName (falling back to the station's id)
    def station_name(id)
      preferences['stations'].select { |h| h['id'] == id }.first['name']
    end

    # TODO: Dupe
    def preferences
      YAML.load_file(Pathname('~/.spritwatch.yml').expand_path)
    end

    class Null
      def present(*)
        warn 'Warning: Evaluation of preferred types and command-line switches yields an empty list'
      end
    end

    class Single < PricePresenter
      attr_reader :type

      def initialize(type)
        @type = type
      end

      def present(stations, prefix = '')
        warn "Prices for #{type.to_s.capitalize} as of #{Time.now}:"

        sorted(stations).each do |station|
          puts "#{prefix}#{station_name(station.id)}: #{station.price(type.to_sym).price}"
        end
      end

      private

      def sorted(stations)
        stations.sort { |a, b| a.price(type) <=> b.price(type) }
      end
    end

    class Multi
      attr_reader :types

      def initialize(types)
        @types = types
      end

      def present(stations)
        warn "Prices as of #{Time.now}:"
        types.each do |type|
          warn "#{type.to_s.capitalize}:"
          Single.new(type).present(stations, '  ')
        end
      end
    end
  end
end
