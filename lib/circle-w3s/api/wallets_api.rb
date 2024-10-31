module CircleW3s
  class WalletsApi
    attr_reader :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end

    # Creates a new developer-controlled wallet or batch of wallets
    def create_wallet(create_wallet_request, x_request_id: nil)
      raise ArgumentError, "create_wallet_request is required" if create_wallet_request.nil?

      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      headers['X-Request-Id'] = x_request_id if x_request_id

      response = api_client.call_api(
        path: '/v1/w3s/developer/wallets',
        http_method: :post,
        headers: headers,
        body: create_wallet_request,
        auth_names: ['BearerAuth'],
        return_type: 'Wallets'
      )
      response.data
    end

    # Retrieves an existing wallet by ID
    def get_wallet(id, x_request_id: nil)
      raise ArgumentError, "id is required" if id.nil?

      headers = { 'Accept' => 'application/json' }
      headers['X-Request-Id'] = x_request_id if x_request_id

      response = api_client.call_api(
        path: '/v1/w3s/wallets/{id}',
        http_method: :get,
        path_params: { 'id' => id },
        headers: headers,
        auth_names: ['BearerAuth'],
        return_type: 'WalletResponse'
      )
      response.data
    end

    # Lists all wallets with optional filters
    def get_wallets(address: nil, blockchain: nil, wallet_set_id: nil, ref_id: nil, 
                   from: nil, to: nil, page_before: nil, page_after: nil, page_size: nil)
      query_params = {}
      query_params[:address] = address if address
      query_params[:blockchain] = blockchain if blockchain
      query_params[:walletSetId] = wallet_set_id if wallet_set_id
      query_params[:refId] = ref_id if ref_id
      query_params[:from] = from.iso8601 if from
      query_params[:to] = to.iso8601 if to
      query_params[:pageBefore] = page_before if page_before
      query_params[:pageAfter] = page_after if page_after
      query_params[:pageSize] = page_size if page_size

      response = api_client.call_api(
        path: '/v1/w3s/wallets',
        http_method: :get,
        query_params: query_params,
        headers: { 'Accept' => 'application/json' },
        auth_names: ['BearerAuth'],
        return_type: 'Wallets'
      )
      response.data
    end

    # Gets token balance for a wallet
    def list_wallet_balance(id, include_all: nil, name: nil, token_address: nil,
                          standard: nil, page_before: nil, page_after: nil, page_size: nil)
      raise ArgumentError, "id is required" if id.nil?

      query_params = {}
      query_params[:includeAll] = include_all unless include_all.nil?
      query_params[:name] = name if name
      query_params[:tokenAddress] = token_address if token_address
      query_params[:standard] = standard if standard
      query_params[:pageBefore] = page_before if page_before
      query_params[:pageAfter] = page_after if page_after
      query_params[:pageSize] = page_size if page_size

      response = api_client.call_api(
        path: '/v1/w3s/wallets/{id}/balances',
        http_method: :get,
        path_params: { 'id' => id },
        query_params: query_params,
        headers: { 'Accept' => 'application/json' },
        auth_names: ['BearerAuth'],
        return_type: 'Balances'
      )
      response.data
    end

    # Gets NFTs for a wallet
    def list_wallet_nfts(id, include_all: nil, name: nil, token_address: nil,
                        standard: nil, page_before: nil, page_after: nil, page_size: nil)
      raise ArgumentError, "id is required" if id.nil?

      query_params = {}
      query_params[:includeAll] = include_all unless include_all.nil?
      query_params[:name] = name if name
      query_params[:tokenAddress] = token_address if token_address
      query_params[:standard] = standard if standard
      query_params[:pageBefore] = page_before if page_before
      query_params[:pageAfter] = page_after if page_after
      query_params[:pageSize] = page_size if page_size

      response = api_client.call_api(
        path: '/v1/w3s/wallets/{id}/nfts',
        http_method: :get,
        path_params: { 'id' => id },
        query_params: query_params,
        headers: { 'Accept' => 'application/json' },
        auth_names: ['BearerAuth'],
        return_type: 'Nfts'
      )
      response.data
    end

    # Updates a wallet's metadata
    def update_wallet(id, update_wallet_request, x_request_id: nil)
      raise ArgumentError, "id is required" if id.nil?
      raise ArgumentError, "update_wallet_request is required" if update_wallet_request.nil?

      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      headers['X-Request-Id'] = x_request_id if x_request_id

      response = api_client.call_api(
        path: '/v1/w3s/wallets/{id}',
        http_method: :put,
        path_params: { 'id' => id },
        headers: headers,
        body: update_wallet_request,
        auth_names: ['BearerAuth'],
        return_type: 'WalletResponse'
      )
      response.data
    end
  end
end