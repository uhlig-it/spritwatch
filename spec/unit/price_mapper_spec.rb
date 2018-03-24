# frozen_string_literal: true

require 'sprit_watch/price'

describe SpritWatch::Price do
  subject(:price) { described_class.new(11.42, '€') }

  it 'has a string representation' do
    expect(price.to_s).to eq('11.42 €')
  end
end
