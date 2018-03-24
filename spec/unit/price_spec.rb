# frozen_string_literal: true

require 'sprit_watch/price'

describe SpritWatch::Price do
  subject(:price) { described_class.new(47.114, '€') }

  it 'has a string representation' do
    expect(price.to_s).to eq('47.114 €')
  end

  it 'is a value object' do
    expect(price).to eq(described_class.new(47.114, '€'))
  end
end
