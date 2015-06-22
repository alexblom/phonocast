require 'minitest/spec'
require 'test_helper'

require 'xml/libxml'

describe Phonocast::Item do
  let(:mp3_path) {
    File.join(PhonocastTest::FIXTURE, '/test.mp3')
  }

  let(:item) {
    Phonocast::Item.new(mp3_path, PhonocastTest::BASE_URL)
  }

  let(:item_author_override) {
    Phonocast::Item.new(mp3_path, "https://github.com/alexblom/phonocast", "New Artist")
  }

  let(:xml) {
    rss = item.rss
    XML::Document.string(rss.to_s)
  }

  let(:enclosure) {
    XmlHelper.item_enclosure(xml)
  }

  describe 'defaults' do
    it 'requires path' do
      assert_raises(ArgumentError) {
        Phonocast::Item.new
      }
    end

    it 'requires base_url' do
      assert_raises(ArgumentError) {
        Phonocast::Item.new('.')
      }
    end

    it 'sets title to mp3 title tag' do
      item.title.must_equal "Phonocast Test mp3"
    end

    it 'defaults to filename if title tag unavailable' do
      no_artist = File.join(PhonocastTest::FIXTURE, '/no_artist.mp3')
      no_artist_item = Phonocast::Item.new(no_artist, PhonocastTest::BASE_URL)

      no_artist_item.title.must_equal "no_artist.mp3"
    end

    it 'sets author to mp3 artist tag' do
      item.author.must_equal "Artist"
    end

    it 'allowed over-ride of author' do
      item_author_override.author.must_equal "New Artist"
    end

    it 'sets duration as mp3 length' do
      item.itunes_duration.must_equal 0.1566875
    end

    it 'sets file size as file size' do
      item.file_size.must_equal 2719
    end

    it 'generates a correct url' do
      expected_link = PhonocastTest::BASE_URL + "/test.mp3"
      item.link.must_equal expected_link
    end

    it 'correctly sets published' do
      refute_nil item.published
    end

    it 'tests optional properties'

  end

  describe 'rss' do
    include XmlHelper

    it 'sets title' do
      title = XmlHelper.get_key(xml, "title")
      title.must_equal item.title
    end

    it 'sets publish date' do
      refute_nil XmlHelper.get_key(xml, "pubDate")
    end

    it 'sets author' do
      author = XmlHelper.get_key(xml, "author")
      author.must_equal item.author
    end

    it 'sets guid to mp3 link' do
      guid = XmlHelper.get_key(xml, "guid")
      guid.must_equal item.link
    end

    it 'sets guid isPermalink tag' do
      permalink = xml.find('guid').
        first.
        attributes.
        get_attribute('isPermaLink').
        value

      permalink.must_equal "true"
    end

    it 'sets duration'

  end

  describe 'rss item enclosure' do
    it 'exists' do
      refute_nil enclosure
    end

    it 'includes a link' do
      enclosure["url"].must_equal item.link
    end

    it 'includes file size' do
      enclosure["length"].must_equal item.file_size.to_s
    end

    it 'tags as mp3' do
      enclosure["type"].must_equal "audio/mp3"
    end
  end
end
