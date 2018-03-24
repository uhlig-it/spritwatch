# frozen_string_literal: true

describe SpritWatch::Client do
  subject(:client) { described_class.new(api_key) }
  let(:lat) { 52.521 }
  let(:lng) { 13.438 }
  let(:rad) { 1.5 }

  describe 'when listing stations' do
    before do
      stub_request(
        :get,
        "https://creativecommons.tankerkoenig.de/json/list.php?apikey=#{api_key}&lat=52.521&lng=13.438&rad=1.5&type=all"
      ).to_return(status: 200, body: body)
    end

    context 'with an illegal API key' do
      let(:api_key) { '00000000-0000-0000-0000-000000000000' }
      let(:body) { fixture('list/wrong_api_key.json').read }

      it 'raises an exception' do
        expect { client.list(latitude: lat, longitude: lng, radius: rad) }.to raise_error do |err|
          expect(err.message).to eq('API-Key existiert nicht')
        end
      end
    end

    context 'with the demo key' do
      let(:api_key) { '00000000-0000-0000-0000-000000000002' }
      let(:body) { fixture('list/ok.json').read }

      it 'has a non-empty result' do
        stations = client.list(latitude: lat, longitude: lng, radius: rad)
        expect(stations).to_not be_empty
      end

      context 'without asking for closed stations' do
        it 'excludes closed stations' do
          stations = client.list(latitude: lat, longitude: lng, radius: rad)
          expect(stations.select { |s| s.brand == 'HEM' }).to be_empty
        end
      end

      context 'asking to include closed stations' do
        it 'includes closed stations' do
          stations = client.list(latitude: lat, longitude: lng, radius: rad, closed: true)
          expect(stations.select { |s| s.brand == 'HEM' }).to_not be_empty
        end
      end
    end
  end

  describe 'when getting prices' do
    before do
      stub_request(
        :get,
        "https://creativecommons.tankerkoenig.de/json/prices.php?apikey=#{api_key}&ids=#{station_ids.join(',')}"
      )
        .to_return(status: 200, body: body)
    end

    context 'with an illegal API key' do
      let(:api_key) { '00000000-0000-0000-0000-000000000000' }
    end

    context 'with the demo key' do
      let(:api_key) { '00000000-0000-0000-0000-000000000002' }
      let(:body) { fixture('prices/ok.json').read }
      let(:station_ids) do
        %w[
          4429a7d9-fb2d-4c29-8cfe-2ca90323f9f8
          446bdcf5-9f75-47fc-9cfa-2c3d6fda1c3b
          60c0eefa-d2a8-4f5c-82cc-b5244ecae955
          44444444-4444-4444-4444-444444444444
        ]
      end

      it 'has a non-empty result' do
        expect(client.prices(station_ids)).not_to be_empty
      end

      it 'contains objects that respond to #closed?' do
        client.prices(station_ids).each do |station|
          expect(station).to respond_to(:closed?)
        end
      end

      it 'contains objects that respond to #price' do
        client.prices(station_ids).each do |station|
          expect(station).to respond_to(:price)
        end
      end

      it 'includes all the stations asked for' do
        stations = client.prices(station_ids)

        station_ids.each do |station_id|
          expect(stations).to include(SpritWatch::Station.new(id: station_id))
        end
      end
    end
  end
end
