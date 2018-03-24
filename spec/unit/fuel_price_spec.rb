# frozen_string_literal: true

require 'sprit_watch/price'

describe SpritWatch::FuelPrice do
  subject(:fuel_price) do
    described_class.new(:diesel, SpritWatch::Price.new(47.114, '€'))
  end

  it 'is a value object' do
    expect(fuel_price).to eq(described_class.new(:diesel, SpritWatch::Price.new(47.114, '€')))
  end

  it 'has a string representation' do
    expect(fuel_price.to_s).to eq('Diesel: 47.114 €')
  end
end
