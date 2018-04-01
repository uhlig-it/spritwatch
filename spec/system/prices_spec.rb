# frozen_string_literal: true

require 'aruba/rspec'

describe 'prices', type: 'aruba' do
  it 'warns about missing preferences' do
    run "bundle exec #{aruba.root_directory}/exe/spritwatch prices"
    expect(last_command_started).to_not be_successfully_executed
    expect(last_command_started).to have_output(/Error/)
  end
end
