module CircleW3s
  class Client
    attr_reader :config, :wallets, :transactions, :user_tokens, :challenge_ids,
                :security_questions, :pin_codes

    def initialize(configuration = CircleW3s.configuration)
      @config = configuration || Configuration.new
      initialize_resources
    end

    def get(path, params = {})
      handle_response { connection.get(path, params) }
    end

    def post(path, body = {})
      puts "Request URL: #{config.api_url}#{path}"
      puts "Request Headers: #{connection.headers}"
      puts "Request Body: #{body.inspect}"
      handle_response { connection.post(path, body) }
    end


    def put(path, body = {})
      handle_response { connection.put(path, body) }
    end

    def delete(path, params = {})
      handle_response { connection.delete(path, params) }
    end

    private

    def initialize_resources
      @wallets = Resources::Wallets.new(self)
      @transactions = Resources::Transactions.new(self)
      @user_tokens = Resources::UserTokens.new(self)
      @challenge_ids = Resources::ChallengeIds.new(self)
      @security_questions = Resources::SecurityQuestions.new(self)
      @pin_codes = Resources::PinCodes.new(self)
    end

    def connection
      @connection ||= Faraday.new(url: config.api_url) do |faraday|
        faraday.request :json
        faraday.response :json
        faraday.adapter Faraday.default_adapter
        
        faraday.headers["Authorization"] = "Bearer #{config.api_key}"
        faraday.headers["Content-Type"] = "application/json"
        faraday.headers["Accept"] = "application/json"
        faraday.headers["User-Agent"] = "CircleW3s Ruby Gem #{CircleW3s::VERSION}"
        faraday.options.timeout = config.timeout
        faraday.options.open_timeout = config.open_timeout
      end

    end

    def handle_response
      response = yield
      return response.body if response.success?

      raise Errors::ApiError.new(response)
    end
  end
end