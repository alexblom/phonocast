require 'mp3info'

require 'rss/2.0'
require 'rss/itunes'

class Phonocast::Item

  attr_accessor :title,
                :published,
                :link,
                :author,
                :file_size,
                :itunes_duration

  def initialize(path, base_url, author_override=nil)
    mp3 = Mp3Info.open(path)
    file = File.open(path)
    file_name = File.basename path

    @itunes_duration = mp3.length
    @file_size = file.size
    @link = "#{base_url}/#{file_name}"

    mp3.tag.title ? @title = mp3.tag.title : @title = file_name
    author_override ? @author = author_override : @author = mp3.tag.artist
    mp3.tag2["TDR"] ? @published = mp3.tag2["TDR"] : @published = file.mtime
  end

  def rss
    item = RSS::Rss::Channel::Item.new

    item.title = @title
    item.author = @author
    item.pubDate = @published

    item.guid = RSS::Rss::Channel::Item::Guid.new
    item.guid.content = @link
    item.guid.isPermaLink = true

    item.enclosure = RSS::Rss::Channel::Item::Enclosure.new
    item.enclosure.url = @link
    item.enclosure.type = "audio/mp3"
    item.enclosure.length = @file_size

    return item
  end
end
