# frozen_string_literal: true

require 'json'
require 'sinatra/base'
require 'sprit_watch/client'

module SpritWatch
  class Server < Sinatra::Base
    set :port, 8080

    post '/init' do
      # TODO: What can we do with this? Is that the overlay file as in http://jamesthom.as/blog/2017/08/04/large-applications-on-openwhisk/?
      warn "Initializing with #{JSON.parse(request.body.read)}"
    end

    post '/run' do
      content_type :json
      params = JSON.parse(request.body.read)
      stations = params.dig('value', 'ids').split(',')
      raise 'Missing parameter for stations' if stations.empty?
      api_key = params.dig('value', 'TANKERKOENIG_API_KEY')
      raise 'Missing parameter for TANKERKOENIG_API_KEY' if api_key.nil? || api_key.empty?

      prices = SpritWatch::Client.new(api_key).prices(stations)
      JSON.dump('result' => { 'msg' => "FYI, prices are: #{prices.map { |s| [s.id, s.price(:diesel).to_s].join(' ') }}" })
    rescue StandardError => error
      status 500
      JSON.dump('result' => { 'msg' => error.message })
    end
  end
end
