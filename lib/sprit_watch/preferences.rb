# frozen_string_literal: true

require 'yaml'

module SpritWatch
  class Preferences
    NoPreferredStations = Class.new(StandardError) do
      def initialize(preferences_file)
        super("No preferred stations defined in #{preferences_file}")
      end
    end

    PreferencesFileNotFound = Class.new(StandardError) do
      def initialize(preferences_file)
        super("Preferences expected in #{preferences_file} but not found")
      end
    end

    PREFERENCES_FILE = Pathname('~/.spritwatch.yml').expand_path

    def initialize
      @preferences_file = PREFERENCES_FILE
      raise PreferencesFileNotFound, @preferences_file unless @preferences_file.exist?
      @preferences = YAML.load_file(@preferences_file) || {}
    end

    def stations
      raise NoPreferredStations, @preferences_file unless @preferences.key?('stations')
      @preferences['stations']
    end

    def types
      @preferences['types']&.map(&:to_sym)
    end
  end
end
