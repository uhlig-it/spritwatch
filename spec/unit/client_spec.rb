# frozen_string_literal: true

describe SpritWatch::Client do
  subject(:client) { described_class.new(api_key) }
  let(:lat) { 52.521 }
  let(:lng) { 13.438 }
  let(:rad) { 1.5 }

  before do
    stub_request(
      :get,
      "https://creativecommons.tankerkoenig.de/json/list.php?apikey=#{api_key}&lat=52.521&lng=13.438&rad=1.5&type=all"
    ).to_return(status: 200, body: body)
  end

  describe 'with an illegal API key' do
    let(:api_key) { '00000000-0000-0000-0000-000000000000' }
    let(:body) { fixture('list/wrong_api_key.json').read }

    it 'raises an exception' do
      expect { client.list(latitude: lat, longitude: lng, radius: rad) }.to raise_error do |err|
        expect(err.message).to eq('API-Key existiert nicht')
      end
    end
  end

  describe 'with the demo key' do
    let(:api_key) { '00000000-0000-0000-0000-000000000002' }
    let(:body) { fixture('list/ok.json').read }

    it 'lists stations' do
      stations = client.list(latitude: lat, longitude: lng, radius: rad)
      expect(stations).to_not be_empty
    end

    it 'excludes closed stations' do
      stations = client.list(latitude: lat, longitude: lng, radius: rad)
      expect(stations.select { |s| s.brand == 'HEM' }).to be_empty
    end

    it 'includes closed stations' do
      stations = client.list(latitude: lat, longitude: lng, radius: rad, closed: true)
      expect(stations.select { |s| s.brand == 'HEM' }).to_not be_empty
    end
  end
end
