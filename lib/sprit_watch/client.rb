# frozen_string_literal: true

# TODO: details
# Parameter-Name  Bedeutung  Werte
# openingTimes  Öffnungszeiten  Array mit Objekten, in denen der Text und die Zeiten stehen
# overrides  erweiterte Öffnungszeiten  Änderungen der regulären ÖZ - bspw. eine temporäre Schliessung
# wholeDay  ganztägig geöffnet  true, false
# state  Bundesland  Ein Kürzel für das Bundesland - ist meist nicht angegeben
#
# Parameter  Bedeutung  Format
# id  ID der Tankstelle  UUID
# apikey  Der persönliche API-Key  UUID
#
# https://creativecommons.tankerkoenig.de/json/detail.php?id=24a381e3-0d72-416d-bfd8-b2f65f6e5802&apikey=00000000-0000-0000-0000-000000000002

require 'rest-client'
require 'json'

require 'sprit_watch/station_list_mapper'
require 'sprit_watch/station_price_mapper'

module SpritWatch
  class Client
    # Parameters:
    # +api_key+  Der persönliche API-Key  UUID
    def initialize(api_key)
      @api_key = api_key
    end

    # Umkreissuche
    #
    # Parameters:
    # +latitude+  geographische Breite des Standortes  Floatingpoint-Zahl
    # +longitude+  geographische Länge  Floatingpoint-Zahl
    # +radius+  Suchradius in km  Floatingpoint-Zahl, max: 25
    # +type+  Spritsorte  :e5, :e10, :diesel, :all. Defaults to :all
    # TODO +sort+  Sortierung  price, dist
    #
    def list(latitude:, longitude:, radius:, type: :all, closed: false)
      station_mapper = StationListMapper.new
      response = fetch_list(latitude: latitude, longitude: longitude, radius: radius, type: type)

      # rubocop:disable Style/MultilineBlockChain
      response['stations'].map do |station|
        station_mapper.map(station)
      end.reject do |station|
        !closed && station.closed?
      end
      # rubocop:enable Style/MultilineBlockChain
    end

    # Preisabfrage
    #
    # Parameter  Bedeutung  Format
    # ids  IDs der Tankstellen  UUIDs, durch Komma getrennt
    def prices(*ids)
      raise 'Stations are missing' if ids.flatten.empty?
      warn 'Warning: Can only query 10 stations at a time' if ids.flatten.size > 10

      station_price_mapper = StationPriceMapper.new

      fetch_prices(ids)['prices'].map do |id, attributes|
        station_price_mapper.map(id, attributes)
      end
    end

    private

    BASE_URI = 'https://creativecommons.tankerkoenig.de/json'

    def fetch_list(latitude:, longitude:, radius:, type:)
      # rubocop:disable Style/MultilineBlockChain
      RestClient.get("#{BASE_URI}/list.php", params: { lat: latitude, lng: longitude, rad: radius, type: type, apikey: @api_key }).yield_self do |response|
        raise response.body if response.code != 200
        JSON.parse(response.body)
      end.tap do |response|
        raise response['message'] unless response['ok'] == true
      end
      # rubocop:enable Style/MultilineBlockChain
    end

    def fetch_prices(*ids)
      # rubocop:disable Style/MultilineBlockChain
      RestClient.get("#{BASE_URI}/prices.php", params: { ids: ids.join(','), apikey: @api_key }).yield_self do |response|
        raise response.body if response.code != 200
        JSON.parse(response.body)
      end.tap do |response|
        raise response['message'] unless response['ok'] == true
      end
      # rubocop:enable Style/MultilineBlockChain
    end
  end
end
