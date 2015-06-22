require 'yaml'

class Phonocast::Configuration

  CONFIGURABLE_KEYS = %i( base_url
                          file_path
                          rss_path
                          image_path
                          title
                          link
                          copyright
                          language
                          description
                          author
                          itunes_block
                          itunes_explicit
                          itunes_keywords
                          itunes_subtitle
                          itunes_summary )

   DEFAULTS = {
    title:       'Phonocast Powered Podcast',
    link:        'https://github.com/alexblom/phonocast',
    file_path:   './',
    description: " ",
    rss_path:    "./phonocast.rss"
   }

  def initialize(opts={})
    #attr_accessor for each CONFIGURABLE_KEY
    setup_attr_accessors

    #Start with a default config
    config = DEFAULTS.clone

    #YAML takes precedence to DEFAULTS
    yaml_path = opts.delete(:yaml_path) || 'phonocast.yaml'
    if File.exists?(yaml_path)

      yaml = YAML.load_file(yaml_path)
      yaml.keys.each do |key|
        yaml[(key.to_sym rescue key) || key] = yaml.delete(key)
      end

      config.merge!(yaml)
    end

    #opts take precedence to YAML
    config.merge!(opts)

    set_instance_variables(config)
  end

  private
    def setup_attr_accessors
      CONFIGURABLE_KEYS.each do |key|
        self.class.__send__(:attr_accessor, key)
      end
    end

    def set_instance_variables(config)
      CONFIGURABLE_KEYS.each do |key|
        instance_variable_set("@#{key.to_s}", config[key])
      end
    end
end
