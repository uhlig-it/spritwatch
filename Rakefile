# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: ['spec:all']

namespace :spec do
  desc 'Run all tests'
  task all: %w[rubocop unit system]

  desc 'Run ci tests'
  task ci: %w[rubocop unit]

  %w[unit system].each do |type|
    desc "Run #{type} tests"
    RSpec::Core::RakeTask.new(type) do |t|
      t.pattern = "spec/#{type}/**/*_spec.rb"
    end
  end
end

RuboCop::RakeTask.new
