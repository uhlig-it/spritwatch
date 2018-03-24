# frozen_string_literal: true

require 'rspec/collection_matchers'
require 'sprit_watch/station'

describe SpritWatch::Station do
  subject(:station) do
    described_class.new(
      id: '387834dc-4244-4091-ae3f-1cbe9dd91c80',
      brand: 'Esso',
      street: 'Bornholmer Str. 33',
      city: 'Berlin'
    )
  end

  it 'has a string representation' do
    expect(station.to_s).to eq('Esso, Bornholmer Str. 33, Berlin')
  end

  it 'can tell whether it is closed' do
    expect(station.closed?).to be_falsey
  end

  it 'is compared by identity' do
    expect(station).to eq(described_class.new(id: '387834dc-4244-4091-ae3f-1cbe9dd91c80'))
    expect(station).to eq(station)
  end

  it 'can be sorted' do
    type = :diesel
    [station, station].sort { |a, b| a.price(type.to_sym) <=> b.price(type.to_sym) }
  end

  context 'when duplicated' do
    let(:duplicate) { station.dup }

    it 'is different' do
      expect(duplicate).to_not eq(station)
    end

    it 'has a proper identity' do
      expect(duplicate.id).to have(36).characters
    end

    it 'retains the attributes of the original' do
      %w[brand street city].each do |attribute|
        expect(duplicate.send(attribute)).to eq(station.send(attribute))
      end
    end
  end
end
