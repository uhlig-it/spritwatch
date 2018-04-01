# frozen_string_literal: true

require 'aruba/rspec'

describe 'prices', type: 'aruba' do
  let(:preferences) do
    {
      'stations' => [
        { 'id' => '95d000e0-48a3-41e1-907f-e32dc9d58525', 'name' => 'Aral Königstraße' }
      ]
    }
  end

  before do
    set_environment_variable('SPRITWATCH_PREFERENCES_FILE', preferences_file)
    set_environment_variable('TANKERKOENIG_API_KEY', '00000000-0000-0000-0000-000000000002')
    run "bundle exec #{aruba.root_directory}/exe/spritwatch prices"
  end

  context 'with a proper preferences file' do
    let(:preferences_file) { Tempfile.new.path }

    before do
      write_file(preferences_file, YAML.dump(preferences))
    end

    it 'shows the prices of the preferred station' do
      expect(last_command_started).to be_successfully_executed
      expect(last_command_started).to have_output(/Aral/)
    end
  end

  context 'with an empty preferences file' do
    let(:preferences_file) { Tempfile.new.path }

    it 'warns about missing preferences' do
      expect(last_command_started).to_not be_successfully_executed
      expect(last_command_started).to have_output(/preferred stations defined/)
    end
  end

  context 'with a non-existing preferences file' do
    let(:preferences_file) { Pathname(Dir.tmpdir) / 'does_not_exist.yml' }

    it 'warns about missing preferences' do
      expect(last_command_started).to_not be_successfully_executed
      expect(last_command_started).to have_output(/file was not found/)
    end
  end
end
