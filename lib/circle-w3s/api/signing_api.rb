module CircleW3s
  class SigningApi
    attr_reader :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end

    # Sign message
    # @param sign_message_request [SignMessageRequest] Request body for signing a message
    # @return [SignatureResponse]
    def sign_message(sign_message_request)
      api_client.fill_entity_secret_ciphertext(sign_message_request)
      api_client.fill_idempotency_key(sign_message_request)

      response = api_client.call_api(
        path: '/v1/w3s/developer/sign/message',
        http_method: :post,
        body: sign_message_request,
        auth_names: ['BearerAuth'],
        return_type: 'SignatureResponse'
      )
      response.data
    end

    # Sign transaction
    # @param sign_transaction_request [SignTransactionRequest] Request body for signing a transaction
    # @return [SignTransactionResponse]
    def sign_transaction(sign_transaction_request)
      api_client.fill_entity_secret_ciphertext(sign_transaction_request)
      api_client.fill_idempotency_key(sign_transaction_request)

      response = api_client.call_api(
        path: '/v1/w3s/developer/sign/transaction',
        http_method: :post,
        body: sign_transaction_request,
        auth_names: ['BearerAuth'],
        return_type: 'SignTransactionResponse'
      )
      response.data
    end

    # Sign typed data
    # @param sign_typed_data_request [SignTypedDataRequest] Request body for signing typed data
    # @return [SignatureResponse]
    def sign_typed_data(sign_typed_data_request)
      api_client.fill_entity_secret_ciphertext(sign_typed_data_request)
      api_client.fill_idempotency_key(sign_typed_data_request)

      response = api_client.call_api(
        path: '/v1/w3s/developer/sign/typedData',
        http_method: :post,
        body: sign_typed_data_request,
        auth_names: ['BearerAuth'],
        return_type: 'SignatureResponse'
      )
      response.data
    end
  end
end