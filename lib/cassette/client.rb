class Cassette::Client

  #A Client is how you interact with Cassette
  #  (via CLI in 99% of cases)
  #
  #Pass a Client configuration opts
  #  Cassette::Client.new(configuration)

  attr_accessor :configuration, :channel

  def initialize(opts={})
    configuration(opts)
  end

  def configuration(opts={})
    @configuration ||= Cassette::Configuration.new(opts)
  end

  def configuration=(opts={})
    @configuration = Cassette::Configuration.new(opts)
  end

  def channel
    @channel ||= Cassette::Channel.new(configuration)
  end

  def setup_yaml
    File.open('cassette.yaml', 'w') do |f|
      f.write(Cassette::Configuration::DEFAULTS.to_yaml)
    end
  end

  #TODO - allow target path
  def create_feed
    channel = Cassette::Channel.new(configuration)
    rss = channel.rss

    File.open("cassette.rss", "w") do |f|
      f.write(rss.to_s)
    end
  end

end
