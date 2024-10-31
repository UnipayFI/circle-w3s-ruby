require 'logger'
require 'uri'
require 'openssl'
require 'base64'

module CircleW3s
  class Configuration
    class << self
      def default
        @default ||= new
      end

      attr_writer :default
    end

    attr_accessor :host, :base_path, :server_index, :server_operation_index,
                  :server_variables, :server_operation_variables,
                  :api_key, :api_key_prefix, :username, :password,
                  :access_token, :entity_secret, :public_key,
                  :verify_ssl, :ssl_ca_cert, :cert_file, :key_file,
                  :debugging, :logger, :temp_folder_path,
                  :datetime_format, :date_format, :proxy, :proxy_headers,
                  :connection_pool_size

    # @param [Hash] opts the options to create a new instance of Configuration
    def initialize(opts = {})
      @host = opts[:host] || "https://api.circle.com"
      @base_path = @host
      @server_index = opts[:server_index] || 0
      @server_operation_index = opts[:server_operation_index] || {}
      @server_variables = opts[:server_variables] || {}
      @server_operation_variables = opts[:server_operation_variables] || {}

      # API Authentication
      @api_key = opts[:api_key] || {}
      @api_key_prefix = opts[:api_key_prefix] || {}
      @username = opts[:username]
      @password = opts[:password]
      @access_token = opts[:api_key]
      @entity_secret = opts[:entity_secret]
      @public_key = opts[:public_key]

      # SSL/TLS
      @verify_ssl = opts[:verify_ssl].nil? ? true : opts[:verify_ssl]
      @ssl_ca_cert = opts[:ssl_ca_cert]
      @cert_file = opts[:cert_file]
      @key_file = opts[:key_file]

      # Logging
      @debugging = opts[:debugging] || false
      @logger = opts[:logger] || Logger.new($stdout)
      @logger.level = @debugging ? Logger::DEBUG : Logger::WARN

      # HTTP
      @proxy = opts[:proxy]
      @proxy_headers = opts[:proxy_headers] || {}
      @connection_pool_size = opts[:connection_pool_size] || (Etc.nprocessors * 5)
      @temp_folder_path = opts[:temp_folder_path]

      # Date Formats
      @datetime_format = opts[:datetime_format] || '%Y-%m-%dT%H:%M:%S.%L%z'
      @date_format = opts[:date_format] || '%Y-%m-%d'

      @read_timeout = opts[:read_timeout] || 60  # 默认60秒
      @open_timeout = opts[:open_timeout] || 60  # 默认60秒

    end

    def generate_entity_secret_ciphertext
      public_key = fetch_public_key unless @public_key
      cipher = OpenSSL::Cipher.new('aes-256-gcm')
      cipher.encrypt
      key = cipher.random_key
      iv = cipher.random_iv
      cipher.auth_data = ""
  
      encrypted = cipher.update(@entity_secret) + cipher.final
      tag = cipher.auth_tag
  
      public_key_obj = OpenSSL::PKey::RSA.new(@public_key)
      encrypted_key = public_key_obj.public_encrypt(key)
      combined = encrypted_key + iv + tag + encrypted
      Base64.strict_encode64(combined)
    end  

    # Get Basic Auth token
    # @return [String] Basic Auth token
    def basic_auth_token
      return nil if @username.nil? || @password.nil?
      ["#{@username}:#{@password}"].pack('m').delete("\r\n")
    end

    # Get API key with prefix
    # @param [String] identifier API key identifier
    # @param [String] alias_name Alternative identifier
    # @return [String] API key with prefix
    def api_key_with_prefix(identifier, alias_name = nil)
      key = @api_key[identifier] || @api_key[alias_name]
      return nil unless key

      prefix = @api_key_prefix[identifier]
      prefix ? "#{prefix} #{key}" : key
    end

    # Get Auth Settings
    # @return [Hash] Auth Settings
    def auth_settings
      auth = {}
      if @access_token
        auth['BearerAuth'] = {
          type: :bearer,
          in: :header,
          format: 'PREFIX:ID:SECRET',
          key: 'Authorization',
          value: "Bearer #{@access_token}"
        }
      end
      auth
    end

    # Get Host URL
    # @param [Integer] index Server index
    # @param [Hash] variables Server variables
    # @return [String] Host URL
    def get_host_from_settings(index = nil, variables = nil)
      return @base_path if index.nil?

      variables ||= {}
      servers = host_settings

      server = servers[index] || raise(ArgumentError, "Invalid index #{index}")
      url = server[:url]

      # Replace variables in URL
      server.fetch(:variables, {}).each do |name, variable|
        value = variables[name] || variable[:default_value]
        
        if variable[:enum_values] && !variable[:enum_values].include?(value)
          raise ArgumentError, "Invalid value #{value} for variable #{name}"
        end

        url = url.gsub("{#{name}}", value.to_s)
      end

      url
    end

    def host=(value)
      @host = value
      @base_path = value
    end

    def host
      @host
    end

    def api_key=(value)
      @api_key = value
      @access_token = value
    end

    def api_key
      @api_key
    end

    def read_timeout
      @read_timeout || 30
    end

    def open_timeout
      @open_timeout || 30
    end
    # Get Host Settings
    # @return [Array<Hash>] Host settings
    def host_settings
      [
        {
          url: "https://api.circle.com",
          description: "No description provided"
        }
      ]
    end

    # Debug Report
    # @return [String] Debug information
    def debug_report
      <<~REPORT
        Ruby SDK Debug Report:
        OS: #{RUBY_PLATFORM}
        Ruby Version: #{RUBY_VERSION}
        API Version: 1.0
        SDK Package Version: 2.1.0
      REPORT
    end

    def get_public_key
      @public_key
    end

    def set_public_key(key)
      @public_key = key
    end
    
    private

    def fetch_public_key
      conn = Faraday.new(url: @host) do |f|
        f.request :json
        f.response :json
      end
      response = conn.get('/v1/w3s/config/entity/publicKey') do |req|
        req.headers['Authorization'] = "Bearer #{@access_token}"
      end
      if response.success?
        @public_key = response.body['data']['publicKey']
      else
        raise "Failed to fetch public key: #{response.body}"
      end
      @public_key
    end
  end

  class << self
    def configure
      Configuration.default ||= Configuration.new
      yield(Configuration.default)
    end

    def configuration
      Configuration.default
    end

    def reset
      Configuration.default = Configuration.new
    end
  end
end