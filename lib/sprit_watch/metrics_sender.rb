# frozen_string_literal: true

module SpritWatch
  class MetricsSender
    def initialize(influxdb_client)
      @influxdb_client = influxdb_client
    end

    # TODO: Handle closed stations
    def update(prices)
      data = prices.map do |station|
        {
          series: 'diesel',
          values: { value: cents_10x(station) },
          tags: {
            station: station.id,
            # TODO: Fetch station details that are not part of the price response
            # brand: station[:brand],
            # street: station[:street],
            # place: station[:place]
          }
        }
      end

      @influxdb_client.write_points(data)
    end

    private

    def cents_10x(station)
      (station.price(:diesel).price.amount * 1000).to_i
    end
  end
end
