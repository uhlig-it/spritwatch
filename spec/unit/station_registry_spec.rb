# frozen_string_literal: true

require 'sprit_watch/station_registry'

describe SpritWatch::StationRegistry do
  subject(:registry) { described_class.new(stations) }
  let(:stations) { [{ 'id' => '4711', 'name' => 'test' }] }
  let(:id) { '4711' }

  it "returns the station's name" do
    expect(subject.lookup(id)).to eq('test')
  end

  it 'knows the ids of all stations' do
    expect(subject.all).to_not be_empty
  end
end
