require 'circle-w3s/version'
require 'circle-w3s/configuration'
require 'circle-w3s/api_client'
require 'circle-w3s/api/wallets_api'
require 'circle-w3s/api/wallet_sets_api'
require 'circle-w3s/api/transactions_api'
require "circle-w3s/models/wallet"
require "circle-w3s/models/wallet_set"
require "circle-w3s/models/transaction"
require "circle-w3s/models/create_wallet_request"
require "circle-w3s/models/create_wallet_set_request"

module CircleW3s
  class Error < StandardError; end
  class ApiError < Error; end
  class UnauthorizedError < ApiError; end
  class NotFoundError < ApiError; end
  class BadRequestError < ApiError; end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration) if block_given?
    end

    def reset
      @configuration = Configuration.new
    end
  end
end