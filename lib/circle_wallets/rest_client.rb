require 'faraday'
require 'json'
require 'logger'

module CircleWallets
  class RestClient
    attr_reader :config, :logger

    def initialize(configuration)
      @config = configuration
      @logger = configuration.logger || Logger.new($stdout)
    end

    def request(method, url, opts = {})
      begin
        response = connection.send(method.to_s.downcase) do |req|
          req.url url
          req.params.merge!(opts[:query_params]) if opts[:query_params]

          req.headers.merge!(opts[:headers] || {})

          if [:post, :put, :patch].include?(method.to_sym) && opts[:body]
            req.body = process_request_body(opts[:body], req.headers['Content-Type'])
          end

          if opts[:timeout]
            req.options.timeout = opts[:timeout]
            req.options.open_timeout = opts[:timeout]
          end
        end

        handle_response(response)
      rescue Faraday::SSLError => e
        raise ApiError.new(message: "SSL Error: #{e.message}")
      rescue Faraday::ConnectionFailed => e
        raise ApiError.new(message: "Connection Error: #{e.message}")
      rescue Faraday::TimeoutError => e
        raise ApiError.new(message: "Timeout Error: #{e.message}")
      rescue Faraday::Error => e
        raise ApiError.new(message: "HTTP Request Failed: #{e.message}")
      end
    end

    [:get, :post, :put, :patch, :delete, :head, :options].each do |method|
      define_method("#{method}_request") do |url, opts = {}|
        request(method, url, opts)
      end
    end

    private

    def connection
      @connection ||= Faraday.new do |faraday|
        faraday.url_prefix = config.host

        faraday.ssl.verify = config.verify_ssl
        faraday.ssl.ca_file = config.ssl_ca_cert if config.ssl_ca_cert
        faraday.ssl.client_cert = config.cert_file if config.cert_file
        faraday.ssl.client_key = config.key_file if config.key_file

        if config.proxy
          faraday.proxy = config.proxy
        end

        faraday.request :json
        faraday.response :json, content_type: /\bjson$/
        faraday.response :logger, logger, bodies: true if config.debugging

        faraday.adapter Faraday.default_adapter
      end
    end

    def process_request_body(body, content_type)
      return body if body.nil?

      case content_type
      when /json/i
        body.is_a?(String) ? body : body.to_json
      when 'application/x-www-form-urlencoded'
        URI.encode_www_form(body)
      when 'multipart/form-data'
        body
      else
        body.to_s
      end
    end

    def handle_response(response)
      @logger.debug "Response: #{response.status} #{response.body}"

      case response.status
      when 200..299
        response
      when 400
        raise BadRequestError.new(response: response)
      when 401
        raise UnauthorizedError.new(response: response)
      when 403
        raise ForbiddenError.new(response: response)
      when 404
        raise NotFoundError.new(response: response)
      when 500..599
        raise ServiceError.new(response: response)
      else
        raise ApiError.new(response: response)
      end
    end
  end

  class BadRequestError < ApiError; end
  class UnauthorizedError < ApiError; end
  class ForbiddenError < ApiError; end
  class NotFoundError < ApiError; end
  class ServiceError < ApiError; end
end