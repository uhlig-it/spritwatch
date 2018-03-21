# frozen_string_literal: true

describe SpritWatch::Station do
  subject(:station) do
    described_class.new(
      id: '0815',
      brand: 'Esso',
      street: 'Bornholmer Str. 11'
    )
  end

  it 'has a string representation' do
    expect(station.to_s).to eq('Esso, Bornholmer Str. 11')
  end

  it 'can tell whether it is closed' do
    expect(station.closed?).to be_falsey
  end
end
