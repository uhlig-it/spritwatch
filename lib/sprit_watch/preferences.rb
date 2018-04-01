# frozen_string_literal: true

require 'yaml'

module SpritWatch
  class Preferences
    NoPreferredStations = Class.new(StandardError) do
      def initialize(preferences_file)
        super("No preferred stations defined in #{preferences_file}.")
      end
    end

    PreferencesFileNotFound = Class.new(StandardError) do
      def initialize(preferences_file)
        super("Preferences expected in #{preferences_file} but the file was not found.")
      end
    end

    PREFERENCES_FILE = '~/.spritwatch.yml'

    def initialize
      @preferences_file = Pathname(ENV['SPRITWATCH_PREFERENCES_FILE'] || PREFERENCES_FILE).expand_path
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
