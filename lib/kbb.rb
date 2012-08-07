require 'savon'
require 'active_support/core_ext/string'

module Kbb; end

Savon.configure do |config|
  # config.log = true
  # config.log_level = :debug
  config.soap_version = 2
end

require 'kbb/version'
require 'kbb/client'
