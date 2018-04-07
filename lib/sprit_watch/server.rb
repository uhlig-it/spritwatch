# frozen_string_literal: true

require 'json'
require 'sinatra/base'
require 'sprit_watch/client'
require 'sprit_watch/metrics_sender'
require 'influxdb'

module SpritWatch
  class Server < Sinatra::Base
    set :port, 8080

    post '/init' do
      warn "Initializing with #{JSON.parse(request.body.read)}"
    end

    post '/run' do
      content_type :json
      params = JSON.parse(request.body.read)['value']
      stations = params['ids'].split(',')
      raise 'Missing parameter for stations' if stations.empty?
      api_key = params['TANKERKOENIG_API_KEY']
      raise 'Missing parameter for TANKERKOENIG_API_KEY' if api_key.nil? || api_key.empty?

      prices = SpritWatch::Client.new(api_key).prices(stations)
      MetricsSender.new(influxdb_client(params)).update(prices)
      JSON.dump('result' => { 'msg' => "FYI, prices are: #{prices.map { |s| [s.id, s.price(:diesel).to_s].join(' ') }}" })
    rescue InfluxDB::ConnectionError => error
      status 500
      JSON.dump('result' => { 'msg' => "Could not deliver metrics: #{error.message}" })
    rescue StandardError => error
      status 500
      JSON.dump('result' => { 'msg' => error.message })
    end

    private

    def influxdb_client(params)
      InfluxDB::Client.new(
        host: params['influxdb_host'],
        port: params['influxdb_port'],
        use_ssl: true,
        database: params['spritwatch_database'],
        username: params['spritwatch_user'],
        password: params['spritwatch_password'],
        retry: 8
      )
    end
  end
end
