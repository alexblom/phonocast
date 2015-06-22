require 'minitest/spec'
require 'test_helper'

require 'xml/libxml'

describe Cassette::Channel do

  let(:channel_opts) {
    {
      file_path:   CassetteTest::FIXTURE,
      description: "New description",
      image_path: 'awesome_logo.jpg'
    }
  }

  let(:channel) {
    client = Cassette::Client.new channel_opts

    client.channel
  }

  let(:channel_without_image) {
    opts = channel_opts.clone
    opts.delete(:image_path)
    client = Cassette::Client.new opts

    client.channel
  }

  let(:xml) {
    XML::Document.string(channel.rss)
  }

  let(:channel_xml) {
    xml.find('//rss/channel').first
  }

  let(:defaults) {
    Cassette::Channel::DEFAULTS
  }

  #Channel will not create due to no opts
  let(:invalid_config_channel) {
    Cassette::Channel.new
  }

  let(:invalid_description_channel) {
    Cassette::Client.new({ description: "" }).channel
  }

  let(:invalid_link_channel) {
    Cassette::Client.new({
      link: ""
    }).channel
  }

  let(:invalid_title_channel) {
    Cassette::Client.new({
      title: ""
    }).channel
  }

  describe 'validations' do
    it 'requires config' do
      assert_raises(ArgumentError) {
        invalid_config_channel
      }
    end

    it 'requires >1char description' do
      assert_raises(ArgumentError) {
        invalid_description_channel
      }
    end

    it 'requires >1char title' do
      assert_raises(ArgumentError) {
        invalid_title_channel
      }
    end

    it 'requires >1char link' do
      assert_raises(ArgumentError) {
        invalid_link_channel
      }
    end

    it 'logs warning if no config.base_url' do
      expected_err = "Warning: No base_url. Download links probably won't work"

      out, err = capture_io do
        channel
      end

      refute_nil err
      err.strip.must_equal expected_err.strip
    end

    it 'does not set image_url if no config.image_path' do
      channel_without_image.image_url.must_equal nil
    end

    it 'has items' do
      channel.items.length.must_equal 2
    end
  end

  describe 'attributes' do
    it 'correctly sets image_url' do
      refute_nil channel.image_url
    end

    it 'image_url is base_url + image_path' do
      expected_url = "#{channel.base_url}/#{channel_opts[:image_path]}"
      channel.image_url.must_equal expected_url
    end

    it 'allows channel.author to override item.author'
  end

  describe 'rss' do
    include XmlHelper

    it 'namespaced xml' do
      href_tag = xml.root.namespaces.find_by_prefix('itunes').href
      expected_href = "http://www.itunes.com/dtds/podcast-1.0.dtd"
      href_tag.must_equal expected_href
    end

    #With no title field, rss will not gen
    it 'has required title field' do
      title = XmlHelper.get_key(channel_xml, "title")
      title.must_equal channel.title
    end

    #With no link field, rss will not gen
    it 'has required link field' do
      link = XmlHelper.get_key(channel_xml, "link")
      link.must_equal channel.link
    end

    #With no description field, rss will not gen
    it 'has required description field' do
      description = XmlHelper.get_key(channel_xml, "description")
      description.must_equal channel.description
    end

    it 'has channel author'

    it 'has itunes_image' do
      image_url = channel_xml.find('itunes:image/@href').first.value
      image_url.must_equal channel.image_url
    end

    it 'has itunes_subtitle'
    it 'has itunes_summary'

    it 'has expected item length' do
      length = channel_xml.find('item').length
      length.must_equal channel.items.length
    end
  end

  it 'finds local target dir pod files eg mp3' do
    #dirty dirty alex
    fixture_count = 2
    channel.items.length.must_equal fixture_count
  end

  it 'items appear in rss' do
    xml = XML::Document.string(channel.rss)
    channel_xml = xml.find('//rss/channel').first
    length = channel_xml.find('item').length

    length.must_equal channel.items.length
  end
end
