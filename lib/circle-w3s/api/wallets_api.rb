module CircleW3s
  class WalletsApi
    attr_reader :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end

    # Create wallets
    # @param [CreateWalletRequest] create_wallet_request Schema for the request payload
    # @param [String] x_request_id Optional request ID for support
    # @return [Wallets]
    def create_wallet(create_wallet_request, x_request_id: nil)
      auto_fill(create_wallet_request)
      
      path = "/v1/w3s/developer/wallets"
      headers = { 'Accept' => 'application/json' }
      headers['X-Request-Id'] = x_request_id if x_request_id
      
      response = api_client.call_api(
        :post,
        path,
        headers: headers,
        body: create_wallet_request,
        auth_names: ['BearerAuth'],
        return_type: 'Wallets'
      )
      response.data
    end

    # Get wallet by ID 
    # @param [String] id Wallet ID
    # @param [String] x_request_id Optional request ID
    # @return [WalletResponse]
    def get_wallet(id, x_request_id: nil) 
      path = "/v1/w3s/wallets/#{id}"
      headers = { 'Accept' => 'application/json' }
      headers['X-Request-Id'] = x_request_id if x_request_id

      response = api_client.call_api(
        :get,
        path,
        headers: headers,
        auth_names: ['BearerAuth'],
        return_type: 'WalletResponse'
      )
      response.data
    end

    # List wallets with filters
    # @param [Hash] opts Optional parameters
    # @option opts [String] :address Filter by blockchain address
    # @option opts [String] :blockchain Filter by blockchain
    # @option opts [String] :wallet_set_id Filter by wallet set
    # @option opts [Integer] :page_size Items per page (max 50)
    # @return [Wallets] 
    def get_wallets(opts = {})
      path = "/v1/w3s/wallets"
      query_params = {}
      
      # Add supported query parameters
      %i[address blockchain wallet_set_id ref_id page_before page_after page_size].each do |key|
        query_params[key] = opts[key] if opts[key]
      end

      # Handle datetime parameters
      if opts[:from]
        query_params[:from] = opts[:from].strftime(api_client.configuration.datetime_format)
      end
      if opts[:to]
        query_params[:to] = opts[:to].strftime(api_client.configuration.datetime_format) 
      end

      response = api_client.call_api(
        :get,
        path,
        query_params: query_params,
        headers: { 'Accept' => 'application/json' },
        auth_names: ['BearerAuth'],
        return_type: 'Wallets'
      )
      response.data
    end

    private

    def auto_fill(request)
      api_client.fill_entity_secret_ciphertext(request)
      api_client.fill_idempotency_key(request)
    end
  end
end