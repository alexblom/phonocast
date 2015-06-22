require 'minitest/spec'
require 'test_helper'

describe Phonocast::Configuration do

  let(:config) {
    Phonocast::Configuration.new
  }

  #Yaml overrides title to YAML Title
  #opts overrides link and language
  let(:modded_config) {
      yaml_path = File.join(PhonocastTest::FIXTURE, 'phonocast.yaml')
      opts = {yaml_path:   yaml_path,
              link:        "https://isleofcode.com",
              language:    "en-us",
              description: "From opts"}

      Phonocast::Configuration.new(opts)
  }

  let(:defaults) {
    Phonocast::Configuration::DEFAULTS
  }

  describe 'defaults init' do
    it 'sets default title' do
      config.title.must_equal defaults[:title]
    end

    it 'sets default link' do
      config.link.must_equal defaults[:link]
    end

    it 'sets default file_path' do
      config.file_path.must_equal defaults[:file_path]
    end

    it 'sets default description' do
      config.description.must_equal defaults[:description]
    end

    it 'each configrable key exists'
    it 'allowed target_rss to be set'

  end

  describe 'attrs from yaml_path' do
    it 'overrode default title' do
      modded_config.title.must_equal "YAML Title"
    end
  end

  describe 'method opts' do
    it 'can set keys' do
      modded_config.language.must_equal "en-us"
    end

    it 'over-rides defaults' do
      modded_config.link.must_equal "https://isleofcode.com"
    end

    it 'over-rode yaml key' do
      modded_config.description.must_equal "From opts"
    end
  end
end
