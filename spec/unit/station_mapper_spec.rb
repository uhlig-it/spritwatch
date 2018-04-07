# frozen_string_literal: true

require 'sprit_watch/price'
require 'sprit_watch/station_list_mapper'

describe SpritWatch::StationListMapper do
  subject(:station) { described_class.new.map(json) }

  context 'Total Station in Sommer-Straße 2' do
    let(:json) { JSON.parse(fixture('list/474e5046-deaf-4f9b-9a32-9797b778f047.json').read) }

    it 'produces a Station' do
      expect(station).to be
    end

    it 'produces a Station with the right id' do
      expect(station.id).to eq('474e5046-deaf-4f9b-9a32-9797b778f047')
    end

    it 'produces a Station with a brand' do
      expect(station.brand.upcase).to eq('TOTAL')
    end

    it 'produces a Station with a closed? attribute' do
      expect(station.closed?).to be_falsey
    end

    it 'produces a Station with a street address' do
      expect(station.street).to eq('MARGARETE-SOMMER-STR. 2')
    end

    it 'produces a Station with a city' do
      expect(station.city.upcase).to eq('BERLIN')
    end

    it 'produces a Station with a price for Diesel' do
      expect(station.price(:diesel)).to eq(SpritWatch::FuelPrice.new(:diesel, SpritWatch::Price.new(1.009, '€')))
    end

    it 'produces a Station with a price for E10' do
      expect(station.price(:e10)).to eq(SpritWatch::FuelPrice.new(:e10, SpritWatch::Price.new(1.009, '€')))
    end

    it 'produces a Station with a price for E5' do
      expect(station.price(:e5)).to eq(SpritWatch::FuelPrice.new(:e5, SpritWatch::Price.new(1.009, '€')))
    end
  end

  context 'HEM' do
    let(:json) { JSON.parse(fixture('list/e1a15081-25a3-9107-e040-0b0a3dfe563c.json').read) }

    it 'produces a Station with a brand' do
      expect(station.brand.upcase).to eq('HEM')
    end

    it 'produces a Station with a closed? attribute' do
      expect(station.closed?).to be_truthy
    end

    it 'produces a Station with a street address' do
      expect(station.street).to eq('Holzmarktstr. 4')
    end
  end
end
