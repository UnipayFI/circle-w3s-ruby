module CircleW3s
  class TransactionsApi
    attr_reader :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end

    # Accelerate a transaction
    # @param id [String] Transaction ID
    # @param accelerate_transaction_request [AccelerateTransactionForDeveloperRequest] Request body
    # @return [AccelerateTransactionForDeveloper]
    def create_developer_transaction_accelerate(id, accelerate_transaction_request)
      path = "/v1/w3s/developer/transactions/#{id}/accelerate"
      response = api_client.call_api(
        path: path,
        http_method: :post,
        body: accelerate_transaction_request,
        auth_names: ['BearerAuth'],
        return_type: 'AccelerateTransactionForDeveloper'
      )
      response.data
    end

    # Cancel a transaction
    # @param id [String] Transaction ID
    # @param cancel_transaction_request [CancelTransactionForDeveloperRequest] Request body
    # @return [CancelTransactionForDeveloper]
    def create_developer_transaction_cancel(id, cancel_transaction_request)
      path = "/v1/w3s/developer/transactions/#{id}/cancel"
      response = api_client.call_api(
        path: path,
        http_method: :post,
        body: cancel_transaction_request,
        auth_names: ['BearerAuth'],
        return_type: 'CancelTransactionForDeveloper'
      )
      response.data
    end

    # Create a contract execution transaction
    # @param request [CreateContractExecutionTransactionForDeveloperRequest] Request body
    # @return [CreateContractExecutionTransactionForDeveloper]
    def create_developer_transaction_contract_execution(request)
      response = api_client.call_api(
        path: '/v1/w3s/developer/transactions/contractExecution',
        http_method: :post,
        body: request,
        auth_names: ['BearerAuth'],
        return_type: 'CreateContractExecutionTransactionForDeveloper'
      )
      response.data
    end

    # Create a transfer transaction
    # @param request [CreateTransferTransactionForDeveloperRequest] Request body
    # @return [CreateTransferTransactionForDeveloperResponse]
    def create_developer_transaction_transfer(request)
      response = api_client.call_api(
        path: '/v1/w3s/developer/transactions/transfer',
        http_method: :post,
        body: request,
        auth_names: ['BearerAuth'],
        return_type: 'CreateTransferTransactionForDeveloperResponse'
      )
      response.data
    end

    # List all transactions
    # @param opts [Hash] Optional parameters
    # @option opts [String] :blockchain Filter by blockchain
    # @option opts [String] :custody_type Filter by custody type
    # @option opts [String] :destination_address Filter by destination address
    # @option opts [Boolean] :include_all Include all resources
    # @option opts [String] :operation Filter by operation
    # @option opts [String] :state Filter by state
    # @option opts [String] :tx_hash Filter by transaction hash
    # @option opts [String] :tx_type Filter by transaction type
    # @option opts [String] :wallet_ids Filter by wallet IDs
    # @option opts [DateTime] :from Start date
    # @option opts [DateTime] :to End date
    # @option opts [String] :page_before Page before token
    # @option opts [String] :page_after Page after token
    # @option opts [Integer] :page_size Page size (1-50)
    # @return [Transactions]
    def list_transactions(opts = {})
      query_params = {}
      
      # Add query parameters
      query_params[:blockchain] = opts[:blockchain] if opts[:blockchain]
      query_params[:custodyType] = opts[:custody_type] if opts[:custody_type]
      query_params[:destinationAddress] = opts[:destination_address] if opts[:destination_address]
      query_params[:includeAll] = opts[:include_all] if opts[:include_all]
      query_params[:operation] = opts[:operation] if opts[:operation]
      query_params[:state] = opts[:state] if opts[:state]
      query_params[:txHash] = opts[:tx_hash] if opts[:tx_hash]
      query_params[:txType] = opts[:tx_type] if opts[:tx_type]
      query_params[:walletIds] = opts[:wallet_ids] if opts[:wallet_ids]
      query_params[:from] = opts[:from].iso8601 if opts[:from]
      query_params[:to] = opts[:to].iso8601 if opts[:to]
      query_params[:pageBefore] = opts[:page_before] if opts[:page_before]
      query_params[:pageAfter] = opts[:page_after] if opts[:page_after]
      query_params[:pageSize] = opts[:page_size] if opts[:page_size]

      response = api_client.call_api(
        path: '/v1/w3s/transactions',
        http_method: :get,
        query_params: query_params,
        auth_names: ['BearerAuth'],
        return_type: 'Transactions'
      )
      response.data
    end

    # Get a single transaction
    # @param id [String] Transaction ID
    # @param tx_type [String] Filter by transaction type
    # @return [TransactionResponse]
    def get_transaction(id, tx_type = nil)
      query_params = {}
      query_params[:txType] = tx_type if tx_type

      response = api_client.call_api(
        path: "/v1/w3s/transactions/#{id}",
        http_method: :get,
        query_params: query_params,
        auth_names: ['BearerAuth'],
        return_type: 'TransactionResponse'
      )
      response.data
    end
  end
end