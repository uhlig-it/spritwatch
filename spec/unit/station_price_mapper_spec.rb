# frozen_string_literal: true

require 'sprit_watch/station_price_mapper'

describe SpritWatch::StationPriceMapper do
  context 'Total Station in Sommer-Straße 2' do
    let(:prices) { JSON.parse(fixture('prices/ok.json').read)['prices'] }
    let(:stations) do
      prices.map do |id, attributes|
        subject.map(id, attributes)
      end
    end

    it 'produces stations' do
      expect(stations).to_not be_empty
      expect(stations.size).to eq(4)
    end

    it 'produces stations with prices' do
      expect(stations).to all(respond_to(:price))
      expect(stations[0].price(:diesel)).to all(be)
    end
  end
end
