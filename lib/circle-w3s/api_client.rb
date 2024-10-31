require 'faraday'
require 'json'
require 'ostruct'

module CircleW3s
  class ApiClient
    attr_accessor :config

    def initialize(config = Configuration.default)
      @config = config
      @conn = Faraday.new(url: config.host) do |f|
        f.request :json
        f.response :json
        f.adapter Faraday.default_adapter
      end
    end

    def call_api(method, path, opts = {})
      response = @conn.send(method, path) do |req|
        req.headers['Authorization'] = "Bearer #{config.access_token}"
        req.body = opts[:body] if opts[:body]
      end

      handle_response(response)
    end

    private

    def handle_response(response)
      if response.success?
        data = response.body
        OpenStruct.new({
          data: data['data'],
          success: true,
          status: response.status
        })
      else
        raise UnauthorizedError.new(response.body) if response.status == 401
        raise ApiError.new("HTTP #{response.status}: #{response.body}")
      end
    end
  end
end