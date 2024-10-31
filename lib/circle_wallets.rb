require "faraday"
require "json"
require "eth"
require "jwt"

require_relative "circle_wallets/version"
require_relative "circle_wallets/configuration"
require_relative "circle_wallets/client"
require_relative "circle_wallets/errors/api_error"

# Resources
require_relative "circle_wallets/resources/wallets"
require_relative "circle_wallets/resources/transactions"
require_relative "circle_wallets/resources/user_tokens"
require_relative "circle_wallets/resources/challenge_ids"
require_relative "circle_wallets/resources/security_questions"
require_relative "circle_wallets/resources/pin_codes"

module CircleWallets
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