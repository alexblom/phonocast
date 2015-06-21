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
    @channel
  end

  def setup_yaml
    File.open('cassette.yaml', 'w') do |f|
      f.write(Cassette::Configuration::DEFAULTS.to_yaml)
    end
  end

  def create_feed
    File.open(channel.rss_path, "w") do |f|
      f.write(channel.rss.to_s)
    end
  end

end
