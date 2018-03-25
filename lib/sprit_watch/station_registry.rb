# frozen_string_literal: true

module SpritWatch
  class StationRegistry
    attr_reader :stations

    def initialize(stations)
      @stations = stations
    end

    # TODO: This may fail; we may need to look it up via Client#details or use a NullName (falling back to the station's id)
    def lookup(id)
      stations.select { |h| h['id'] == id }.first['name']
    end

    def all
      stations.map { |s| s['id'] }
    end
  end
end
