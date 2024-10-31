module CircleWallets
  class WalletSetsApi
    attr_reader :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end

    # Creates a new wallet set
    def create_wallet_set(create_wallet_set_request, x_request_id: nil)
      raise ArgumentError, "create_wallet_set_request is required" if create_wallet_set_request.nil?

      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      headers['X-Request-Id'] = x_request_id if x_request_id

      response = api_client.call_api(
        path: '/v1/w3s/developer/walletSets',
        http_method: :post,
        headers: headers,
        body: create_wallet_set_request,
        auth_names: ['BearerAuth'],
        return_type: 'WalletSetResponse'
      )
      response.data
    end

    # Gets a specific wallet set by ID
    def get_wallet_set(id, x_request_id: nil)
      raise ArgumentError, "id is required" if id.nil?

      headers = { 'Accept' => 'application/json' }
      headers['X-Request-Id'] = x_request_id if x_request_id

      response = api_client.call_api(
        path: '/v1/w3s/walletSets/{id}',
        http_method: :get,
        path_params: { 'id' => id },
        headers: headers,
        auth_names: ['BearerAuth'],
        return_type: 'WalletSetResponse'
      )
      response.data
    end

    # Lists all wallet sets with optional filtering
    def get_wallet_sets(x_request_id: nil, from: nil, to: nil, 
                       page_before: nil, page_after: nil, page_size: nil)
      query_params = {}
      query_params[:from] = from.iso8601 if from
      query_params[:to] = to.iso8601 if to
      query_params[:pageBefore] = page_before if page_before
      query_params[:pageAfter] = page_after if page_after
      query_params[:pageSize] = page_size if page_size

      headers = { 'Accept' => 'application/json' }
      headers['X-Request-Id'] = x_request_id if x_request_id

      response = api_client.call_api(
        path: '/v1/w3s/walletSets',
        http_method: :get,
        query_params: query_params,
        headers: headers,
        auth_names: ['BearerAuth'],
        return_type: 'WalletSets'
      )
      response.data
    end

    # Updates a wallet set
    def update_wallet_set(id, update_wallet_set_request, x_request_id: nil)
      raise ArgumentError, "id is required" if id.nil?
      raise ArgumentError, "update_wallet_set_request is required" if update_wallet_set_request.nil?

      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      headers['X-Request-Id'] = x_request_id if x_request_id

      response = api_client.call_api(
        path: '/v1/w3s/developer/walletSets/{id}',
        http_method: :put,
        path_params: { 'id' => id },
        headers: headers,
        body: update_wallet_set_request,
        auth_names: ['BearerAuth'],
        return_type: 'WalletSetResponse'
      )
      response.data
    end
  end
end