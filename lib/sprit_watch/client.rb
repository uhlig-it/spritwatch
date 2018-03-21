# frozen_string_literal: true

# prices
# Parameter  Bedeutung  Format
# ids  IDs der Tankstellen  UUIDs, durch Komma getrennt
# apikey  Der persönliche API-Key  UUID
#
# https://creativecommons.tankerkoenig.de/json/prices.php?ids=4429a7d9-fb2d-4c29-8cfe-2ca90323f9f8,446bdcf5-9f75-47fc-9cfa-2c3d6fda1c3b,60c0eefa-d2a8-4f5c-82cc-b5244ecae955,44444444-4444-4444-4444-444444444444&apikey=00000000-0000-0000-0000-000000000002
#
# details
# Parameter-Name  Bedeutung  Werte
# openingTimes  Öffnungszeiten  Array mit Objekten, in denen der Text und die Zeiten stehen
# overrides  erweiterte Öffnungszeiten  Änderungen der regulären ÖZ - bspw. eine temporäre Schliessung
# wholeDay  ganztägig geöffnet  true, false
# state  Bundesland  Ein Kürzel für das Bundesland - ist meist nicht angegeben
# Parameter  Bedeutung  Format
# id  ID der Tankstelle  UUID
# apikey  Der persönliche API-Key  UUID
#
# https://creativecommons.tankerkoenig.de/json/detail.php?id=24a381e3-0d72-416d-bfd8-b2f65f6e5802&apikey=00000000-0000-0000-0000-000000000002

require 'rest-client'
require 'json'

module SpritWatch
  class Client
    def initialize(api_key)
      @api_key = api_key
    end

    # Umkreissuche
    #
    # Parameters:
    # +lat+  geographische Breite des Standortes  Floatingpoint-Zahl
    # +lng+  geographische Länge  Floatingpoint-Zahl
    # +rad+  Suchradius in km  Floatingpoint-Zahl, max: 25
    # +type+  Spritsorte  :e5, :e10, :diesel, :all. Defaults to :all
    # +sort+  Sortierung  price, dist
    # +apikey+  Der persönliche API-Key  UUID
    #
    def list(latitude:, longitude:, radius:, type: :all)
      json = JSON.parse(fetch(latitude: latitude, longitude: longitude, radius: radius, type: type))
      raise json['message'] unless json['ok'] == true

      station_mapper = StationMapper.new
      json['stations'].map do |station|
        station_mapper.map(station)
      end
    end

    private

    BASE_URI = 'https://creativecommons.tankerkoenig.de/json'

    def fetch(latitude:, longitude:, radius:, type:)
      RestClient.get("#{BASE_URI}/list.php", params: { lat: latitude, lng: longitude, rad: radius, type: type, apikey: @api_key }).tap do |response|
        raise response.body if response.code != 200
      end
    end
  end
end
