# frozen_string_literal: true

require 'json'
require 'sinatra/base'

module SpritWatch
  class Server < Sinatra::Base
    set :port, 8080

    post '/init' do
      # TODO What can we do with this? Is that the overlay file as in http://jamesthom.as/blog/2017/08/04/large-applications-on-openwhisk/?
      warn "Initializing with #{JSON.parse(request.body.read)}"
    end

    # test with
    # curl -H "Content-Type: application/json" -X POST -d '{"value": {"ids": [4711,851]}}' http://localhost:8080/run
    post '/run' do
      content_type :json
      params = JSON.parse(request.body.read)
      stations = params.dig('value', 'ids').split(',')
      raise "Missing parameter for stations" if stations.empty?
      JSON.dump('result' => { 'msg' => "TODO: fetch prices for #{stations.size} stations: #{stations}" })
    rescue StandardError => error
      status 500
      JSON.dump('result' => { 'msg' => error.message })
    end
  end
end
