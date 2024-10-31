module CircleW3s
  class TokenLookupApi
    attr_reader :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end

    # Get token details
    # @param id [String] The universally unique identifier (UUID v4) of the token
    # @return [TokenResponse] Token details
    def get_token_id(id)
      # Auto fill required fields
      api_client.fill_entity_secret_ciphertext(id)
      api_client.fill_idempotency_key(id)

      response = api_client.call_api(
        path: "/v1/w3s/tokens/#{id}",
        http_method: :get,
        auth_names: ['BearerAuth'],
        return_type: 'TokenResponse'
      )
      response.data
    end

    # Get token details with HTTP info
    # @param id [String] The universally unique identifier (UUID v4) of the token
    # @param opts [Hash] Optional parameters
    # @option opts [Boolean] :_return_http_data_only Only return the response data
    # @option opts [Boolean] :_preload_content Preload response content
    # @option opts [Integer, Array<Integer>] :_request_timeout Request timeout
    # @return [ApiResponse] Response with HTTP info
    def get_token_id_with_http_info(id, opts = {})
      # Auto fill required fields
      api_client.fill_entity_secret_ciphertext(id)
      api_client.fill_idempotency_key(id)

      # Validate parameters
      raise ArgumentError, "Missing required parameter 'id'" if id.nil?

      # Process parameters
      path_params = { 'id' => id }
      query_params = {}
      header_params = {}
      form_params = {}
      body_params = nil

      # Set HTTP headers
      header_params['Accept'] = api_client.select_header_accept(['application/json'])

      # Make API call
      api_client.call_api(
        path: '/v1/w3s/tokens/{id}',
        http_method: :get,
        path_params: path_params,
        query_params: query_params,
        header_params: header_params,
        body: body_params,
        auth_names: ['BearerAuth'],
        return_type: 'TokenResponse',
        opts: opts
      )
    end
  end
end