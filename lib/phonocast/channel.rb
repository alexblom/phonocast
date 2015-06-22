require 'rss/2.0'
require 'rss/itunes'

class Phonocast::Channel

  #A Channel represents a Podcast Channel
  #  (e.g. Hardcore History)
  #
  #A channel has many items (shows)

  attr_accessor :title,
                :file_path,
                :rss_path,
                :description,
                :link,
                :image_url,
                :base_url,
                :copyright,
                :items,
                :language,
                :author,
                :itunes_block,
                :itunes_explicit,
                :itunes_keywords,
                :itunes_subtitle,
                :itunes_summary

  ALLOWED_EXTENSIONS = ['*.m4a',
                        '*.mp3' ,
                        '*.mov',
                        '*.mp4',
                        '*.m4v',
                        '*.pdf',
                        '*.epub']

  def initialize(config)
    validate_config(config)

    @title = config.title
    @file_path = config.file_path
    @rss_path = config.rss_path
    @description = config.description
    @link = config.link
    @base_url = config.base_url || @link
    @copyright = config.copyright
    @author = config.author
    @itunes_subtitle = config.itunes_subtitle
    @itunes_summary = config.itunes_summary
    @language = config.language
    @itunes_block = config.itunes_block

    @image_url = "#{@base_url}/#{config.image_path}" if config.image_path

    @items = []
    init_items
  end

  #title, link & description req for rss output
  def rss
    rss = RSS::Rss.new("2.0")
    channel = RSS::Rss::Channel.new

    channel.title = @title
    channel.link = @link
    channel.description = @description
    channel.generator = "Phonocast #{Phonocast::VERSION}"
    #channel.author = @author
    channel.itunes_image = RSS::ITunesChannelModel::ITunesImage.new(@image_url)
    channel.itunes_subtitle = @itunes_subtitle
    channel.itunes_summary = @itunes_summary

    @items.each do |item|
      channel.items << item.rss
    end

    rss.channel = channel

    return rss.to_s
  end

  private
    def validate_config(config)
      if !config.base_url
        warn "Warning: No base_url. Download links probably won't work"
      end

      [config.description,
       config.title,
       config.link].each do |key|
         if !key || key.length < 1
           raise ArgumentError.new("#{key} must be >1 char")
         end
       end
    end

    def init_items
      podcast_files = collect_podcast_files(@file_path)
      podcast_files.each do |file_name|
        path = File.join(@file_path, file_name)
        @items.push(Phonocast::Item.new(path, @base_url))
      end
    end

    def collect_podcast_files(file_path)
      podcast_files = []
      Dir.chdir(file_path) do
        podcast_files = Dir.glob(ALLOWED_EXTENSIONS)
      end

      return podcast_files
    end
end
