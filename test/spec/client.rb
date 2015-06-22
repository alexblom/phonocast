require 'minitest/spec'
require 'test_helper'
require 'yaml'

describe Phonocast::Client do
  let(:client) {
    opts = { base_url: "http://alexblom.com" }
    Phonocast::Client.new(opts)
  }
  let(:client) {
    opts = { base_url: "http://alexblom.com" }
    Phonocast::Client.new(opts)
  }

  let(:yaml_filename) { "phonocast.yaml" }
  let(:rss_filepath) { "phonocast.rss" }
  let(:new_rss_filepath) { "sexy_podcast.rss" }

  let(:yaml) {
    YAML.load_file( yaml_filename )
  }

  it 'initializes' do
    refute_nil client
  end

  it 'creates a configuration object' do
    client.configuration.class.must_equal Phonocast::Configuration
  end

  it 'passes opts to configuration' do
    client.configuration.base_url.must_equal "http://alexblom.com"
  end

  describe 'setup_yaml' do
    before do
      client.setup_yaml
    end

    after do
      FileUtils.rm( yaml_filename )
    end

    it 'creates a yaml file' do
      File.exists?( yaml_filename ).must_equal true
    end

    it 'writes default title' do
      refute_nil yaml[:description]
    end

    it 'writes default link' do
      refute_nil yaml[:link]
    end

    it 'writes default file_path' do
      refute_nil yaml[:file_path]
    end

    it 'writes default description' do
      refute_nil yaml[:description]
    end
  end

  describe 'create_feed' do
    it 'create_feed writes an rss file' do
      client.create_feed

      File.exists?( rss_filepath ).must_equal true

      FileUtils.rm( rss_filepath )
    end
    it 'allows output filename to change' do
      client.channel.rss_path = new_rss_filepath
      client.create_feed

      File.exists?( new_rss_filepath ).must_equal true

      FileUtils.rm( new_rss_filepath )
    end

  end
end
