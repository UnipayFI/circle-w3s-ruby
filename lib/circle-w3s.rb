require "faraday"
require "json"
require "eth"
require "jwt"

require_relative "circle-w3s/version"
require_relative "circle-w3s/configuration"
require_relative "circle-w3s/client"
require_relative "circle-w3s/errors/api_error"

# Resources
require_relative "circle-w3s/resources/wallets"
require_relative "circle-w3s/resources/transactions"
require_relative "circle-w3s/resources/user_tokens"
require_relative "circle-w3s/resources/challenge_ids"
require_relative "circle-w3s/resources/security_questions"
require_relative "circle-w3s/resources/pin_codes"

module CircleW3s
  class Error < StandardError; end
  
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  def self.reset
    self.configuration = Configuration.new
  end

  def self.client
    @client ||= Client.new(configuration)
  end
end