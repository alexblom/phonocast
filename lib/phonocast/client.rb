class Phonocast::Client

  #A Client is how you interact with Phonocast
  #  (via CLI in 99% of cases)
  #
  #Pass a Client configuration opts
  #  Phonocast::Client.new(configuration)

  attr_accessor :configuration, :channel

  def initialize(opts={})
    configuration(opts)
  end

  def configuration(opts={})
    @configuration ||= Phonocast::Configuration.new(opts)
  end

  def configuration=(opts={})
    @configuration = Phonocast::Configuration.new(opts)
  end

  def channel
    @channel ||= Phonocast::Channel.new(configuration)
    @channel
  end

  def setup_yaml
    File.open('phonocast.yaml', 'w') do |f|
      f.write(Phonocast::Configuration::DEFAULTS.to_yaml)
    end
  end

  def create_feed
    File.open(channel.rss_path, "w") do |f|
      f.write(channel.rss.to_s)
    end
  end

end
