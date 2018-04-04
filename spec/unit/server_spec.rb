# frozen_string_literal: true

require 'sprit_watch/server'
require 'rack/test'
require 'json'

describe SpritWatch::Server do
  include Rack::Test::Methods

  def app
    described_class
  end

  before do
    allow_any_instance_of(SpritWatch::Client).to receive(:prices).and_return(prices)
  end

  let(:prices) { [] }

  it 'can be initialized' do
    post '/init', {
      binary: false,
      code: 'unused'
    }.to_json
    expect(last_response).to be_ok
  end

  it 'can be called with proper payload' do
    post '/run', {
      value: {
        ids: '4711, 851',
        TANKERKOENIG_API_KEY: '00000000-0000-0000-0000-000000000002'
      }
    }.to_json

    expect(last_response).to be_ok
    expect(last_response.body).to include('prices are')
  end

  it 'can be called without payload' do
    post '/run'
    expect(last_response).to_not be_ok
  end
end
