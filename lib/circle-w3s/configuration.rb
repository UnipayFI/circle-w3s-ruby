require 'logger'
require 'uri'

module CircleW3s
  class Configuration
    DEFAULT_BASE_PATH = "https://api.circle.com".freeze
    DEFAULT_USER_AGENT = "CircleW3s Ruby Gem #{CircleW3s::VERSION}".freeze

    attr_accessor :api_key, :api_key_prefix
    attr_accessor :username, :password
    attr_accessor :access_token
    attr_accessor :entity_secret
    attr_accessor :public_key
    attr_accessor :verify_ssl
    attr_accessor :ssl_ca_cert
    attr_accessor :cert_file
    attr_accessor :key_file
    attr_accessor :timeout
    attr_accessor :debugging
    attr_accessor :logger
    attr_accessor :proxy
    attr_accessor :proxy_headers
    attr_writer :host

    def initialize
      @host = DEFAULT_BASE_PATH
      @verify_ssl = true
      @timeout = 60
      @debugging = false
      @api_key = {}
      @api_key_prefix = {}
      @logger = Logger.new($stdout)
      @logger.level = Logger::WARN
      reset_api_client
    end

    def host
      uri = URI.parse(@host)
      "#{uri.scheme}://#{uri.host}#{[uri.port].compact.join(':')}"
    end

    def debugging=(debug_flag)
      @debugging = debug_flag
      if @debugging
        @logger.level = Logger::DEBUG
      else
        @logger.level = Logger::WARN
      end
    end

    def api_key_with_prefix(identifier)
      if api_key[identifier] && api_key_prefix[identifier]
        "#{api_key_prefix[identifier]} #{api_key[identifier]}"
      elsif api_key[identifier]
        api_key[identifier]
      end
    end

    def basic_auth_token
      return unless username || password
      
      require 'base64'
      Base64.strict_encode64("#{username}:#{password}")
    end

    def auth_settings
      {
        'BearerAuth' => {
          type: :bearer,
          in: :header,
          format: 'PREFIX:ID:SECRET',
          key: 'Authorization',
          value: "Bearer #{access_token}"
        }.compact
      }.select { |_, v| v[:value] }
    end

    def reset_api_client
      @api_client = nil
    end

    def debug_report
      <<~REPORT
        Ruby SDK Debug Report:
        OS: #{RUBY_PLATFORM}
        Ruby Version: #{RUBY_VERSION}
        API Version: 1.0
        SDK Package Version: #{CircleW3s::VERSION}
      REPORT
    end

    class << self
      attr_accessor :default

      def default
        @default ||= Configuration.new
      end
    end
  end
end