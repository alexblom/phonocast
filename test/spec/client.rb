require 'minitest/spec'
require 'test_helper'
require 'yaml'

describe Cassette::Client do
  let(:client) {
    Cassette::Client.new({
      "base_url" => "http://alexblom.com"
    })
  }

  let(:yaml) {
    YAML.load_file('cassette.yaml')
  }

  it 'initializes' do
    refute_nil client
  end

  it 'creates a configuration object' do
    client.configuration.class.must_equal Cassette::Configuration
  end

  it 'passes opts to configuration' do
    client.configuration.base_url.must_equal "http://alexblom.com"
  end

  describe 'setup_yaml' do
    before do
      client.setup_yaml
    end

    after do
      FileUtils.rm('cassette.yaml')
    end

    it 'creates a yaml file' do
      File.exists?("cassette.yaml").must_equal true
    end

    it 'writes default title' do
      refute_nil yaml["description"]
    end

    it 'writes default link' do
      refute_nil yaml["link"]
    end

    it 'writes default file_path' do
      refute_nil yaml["file_path"]
    end

    it 'writes default description' do
      refute_nil yaml["description"]
    end
  end

  it 'create_feed writes an rss file' do
    client.create_feed

    File.exists?("cassette.rss").must_equal true

    #RM
    FileUtils.rm('cassette.rss')
  end
end
