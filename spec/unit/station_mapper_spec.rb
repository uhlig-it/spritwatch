# frozen_string_literal: true

describe SpritWatch::StationMapper do
  let(:json) { JSON.parse(fixture('list/474e5046-deaf-4f9b-9a32-9797b778f047.json').read) }

  it 'produces a Station' do
    station = subject.map(json)
    expect(station).to be
  end

  it 'produces a Station with the right id' do
    station = subject.map(json)
    expect(station.id).to eq('474e5046-deaf-4f9b-9a32-9797b778f047')
  end

  it 'produces a Station with a brand' do
    station = subject.map(json)
    expect(station.brand.upcase).to eq('TOTAL')
  end

  it 'produces a Station with a price for Diesel' do
    station = subject.map(json)
    expect(station.price(:diesel)).to eq(1.009)
  end
end
