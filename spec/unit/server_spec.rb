# frozen_string_literal: true

require 'sprit_watch/server'
require 'sprit_watch/metrics_sender'
require 'rack/test'
require 'json'

describe SpritWatch::Server do
  include Rack::Test::Methods

  def app
    described_class
  end

  before do
    allow_any_instance_of(SpritWatch::Client).to receive(:prices).and_return(prices)
    allow_any_instance_of(app).to receive(:influxdb_client).and_return(influxdb_client)
    allow(influxdb_client).to receive(:write_points)
  end

  let(:eleven_fourty_two) { double('fuel price', amount: 1.142) }

  let(:prices) do
    [
      SpritWatch::Station.new(id: '4711').tap { |s| allow(s).to receive(:price).with(:diesel).and_return(double('fuel price', price: double('price', amount: 1.142))) },
      SpritWatch::Station.new(id: '0815').tap { |s| allow(s).to receive(:price).with(:diesel).and_return(double('fuel price', price: double('price', amount: 0.815))) }
    ]
  end

  let(:influxdb_client) do
    double('InfluxDB client')
  end

  # Simulate that OpenWhisk adds all params from when the action was created
  # by merging these with the invocation parameters
  let(:action_params) do
    {
      TANKERKOENIG_API_KEY: '00000000-0000-0000-0000-000000000002',
      influxdb_host: 'dummy-host',
      influxdb_port: 'dummy-port',
      spritwatch_database: 'dummy-database',
      spritwatch_user: 'dummy-user',
      spritwatch_password: 'dummy-password'
    }
  end

  it 'can be initialized' do
    post '/init', {
      binary: false,
      code: 'unused'
    }.to_json
    expect(last_response).to be_ok
  end

  it 'can be called with proper payload' do
    post '/run', { value: action_params.merge(ids: '4711, 0815') }.to_json

    expect(last_response).to be_ok
    expect(last_response.body).to include('prices are')
  end

  it 'can be called without payload' do
    post '/run'
    expect(last_response).to_not be_ok
  end

  it 'sends the prices to an InfluxDB instance' do
    expect(influxdb_client).to receive(:write_points) do |points|
      # not sure why these don't work ...
      expect(points.size).to eq(2)
      expect(points[0][:series]).to eq('diesel')
      expect(points[1][:series]).to eq('diesel')
    end

    post '/run', { value: action_params.merge(ids: '4711, 0815') }.to_json
  end
end
