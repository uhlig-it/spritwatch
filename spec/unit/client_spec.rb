# frozen_string_literal: true

describe SpritWatch::Client do
  subject(:client) { described_class.new(api_key) }
  let(:lat) { 52.521 }
  let(:lng) { 13.438 }
  let(:rad) { 1.5 }

  describe 'with an illegal API key' do
    let(:api_key) { '00000000-0000-0000-0000-000000000000' }

    it 'raises an exception' do
      expect { client.list(latitude: lat, longitude: lng, radius: rad) }.to raise_error do |err|
        expect(err.message).to eq('API-Key existiert nicht')
      end
    end
  end

  describe 'with the demo key' do
    let(:api_key) { '00000000-0000-0000-0000-000000000002' }

    it 'lists stations' do
      stations = client.list(latitude: lat, longitude: lng, radius: rad)
      expect(stations).to_not be_empty
    end
  end
end
