# frozen_string_literal: true

describe SpritWatch::FuelPrice do
  subject(:price) { described_class.new(type, euros) }
  let(:type) { :diesel }
  let(:euros) { 47.11 }

  it 'has a string representation' do
    expect(price.to_s).to eq('Diesel: 47,11 €')
  end
end
