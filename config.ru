# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('lib', __dir__))
require 'sprit_watch/server'
SpritWatch::Server.run!
