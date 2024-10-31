require 'date'
require 'json'
require 'tempfile'
require 'uri'
require 'faraday'

module CircleW3s
  class ApiClient
    attr_accessor :config, :default_headers, :user_agent
    
    def initialize(configuration = Configuration.new)
      @config = configuration
      @user_agent = "CircleW3s Ruby Gem #{CircleW3s::VERSION}"
      @default_headers = {
        'Content-Type' => 'application/json',
        'User-Agent' => @user_agent
      }
      @default_headers['Authorization'] = "Bearer #{@config.api_key}" if @config.api_key
    end

    # 发起请求
    def call_api(http_method, path, opts = {})
      response = connection.send(http_method.to_s.downcase) do |req|
        # 构建请求 URL
        req.url build_request_url(path, opts[:query])
        
        # 设置请求头
        req.headers = build_request_headers(opts[:header])
        
        # 设置请求体
        if [:post, :put, :patch].include?(http_method)
          req.body = build_request_body(opts[:body])
        end
        
        # 设置超时
        req.options.timeout = @config.timeout if @config.timeout
        req.options.open_timeout = @config.open_timeout if @config.open_timeout
      end

      handle_response(response)
    rescue Faraday::Error => e
      raise ApiError.new(response: e.response)
    end

    private

    def connection
      @connection ||= Faraday.new do |faraday|
        faraday.url_prefix = @config.host
        faraday.request :json
        faraday.response :json, content_type: /\bjson$/
        faraday.adapter Faraday.default_adapter
        
        if @config.proxy
          faraday.proxy = @config.proxy
        end

        if @config.ssl_ca_cert
          faraday.ssl.ca_file = @config.ssl_ca_cert
        end

        if @config.cert_file
          faraday.ssl.client_cert = @config.cert_file
        end

        if @config.key_file
          faraday.ssl.client_key = @config.key_file
        end

        faraday.ssl.verify = @config.verify_ssl
      end
    end

    def build_request_url(path, query_params = nil)
      url = path.to_s

      if query_params && !query_params.empty?
        # 将查询参数转换为字符串
        query_string = query_params.map do |key, value|
          "#{URI.encode_www_form_component(key.to_s)}=#{URI.encode_www_form_component(value.to_s)}"
        end.join('&')
        
        url += "?#{query_string}"
      end

      url
    end

    def build_request_headers(custom_headers = nil)
      headers = default_headers.dup
      
      if custom_headers
        headers.merge!(custom_headers)
      end

      # 添加认证信息
      if (auth_settings = @config.auth_settings).any?
        auth_settings.each do |auth|
          if auth[:in] == :header
            headers[auth[:key]] = auth[:value]
          end
        end
      end

      headers
    end

    def build_request_body(data)
      return nil if data.nil?
      
      if data.is_a?(String)
        data
      else
        sanitize_for_serialization(data)
      end
    end

    def handle_response(response)
      case response.status
      when 200..299
        response.body
      else
        raise ApiError.new(
          code: response.status,
          response: response
        )
      end
    end

    def sanitize_for_serialization(obj)
      case obj
      when nil
        nil
      when String, Integer, Float, TrueClass, FalseClass
        obj
      when Date
        obj.iso8601
      when Time, DateTime
        obj.strftime('%Y-%m-%dT%H:%M:%S.%L%z')
      when Array
        obj.map { |item| sanitize_for_serialization(item) }
      when Hash
        obj.transform_values { |value| sanitize_for_serialization(value) }
      else
        if obj.respond_to?(:to_hash)
          sanitize_for_serialization(obj.to_hash)
        else
          raise ApiError.new(message: "Unable to serialize #{obj.class} object")
        end
      end
    end

    def deserialize(response_data, return_type)
      case return_type
      when nil
        nil
      when 'String'
        response_data.to_s
      when 'Integer'
        response_data.to_i
      when 'Float'
        response_data.to_f
      when 'Boolean'
        response_data == true
      when 'DateTime'
        DateTime.parse(response_data)
      when 'Date'
        Date.parse(response_data)
      when 'Object'
        response_data
      when /\AArray<(.+)>\z/
        inner_type = $1
        response_data.map { |item| deserialize(item, inner_type) }
      when /\AHash\<String, (.+)\>\z/
        inner_type = $1
        response_data.transform_values { |value| deserialize(value, inner_type) }
      else
        # 假设是一个模型类
        const_get("CircleW3s::Models::#{return_type}").new(response_data)
      end
    end
  end
end