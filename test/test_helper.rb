require 'cassette'
require 'minitest/autorun'

require 'helper/xml_helper'

module CassetteTest
  FIXTURE = File.join('/', File.dirname(__FILE__), 'fixtures')
  BASE_URL = "https://github.com/alexblom/cassette"
end
