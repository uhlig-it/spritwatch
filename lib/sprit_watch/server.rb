# frozen_string_literal: true

require 'json'
require 'sinatra/base'

module SpritWatch
  class Server < Sinatra::Base
    set :port, 8080

    post '/init' do
      warn "Initializing with #{request.params}"
    end

    # test with
    # curl -H "Content-Type: application/json" -X POST -d '{"value": {"ids": [4711,851]}}' http://localhost:8080/run
    post '/run' do
      content_type :json
      params = JSON.parse(request.body.read)
      stations = params.dig('value', 'ids') || '95d000e0-48a3-41e1-907f-e32dc9d58525'
      JSON.dump('result' => { 'msg' => "TODO: fetch prices for #{stations.size} stations: #{stations}" })
    rescue StandardError => error
      status 500
      JSON.dump('result' => { 'msg' => error.message })
    end
  end
end
