module CircleW3s
  class Transaction
    attr_accessor :id, :abi_function_signature, :abi_parameters, :amounts,
                  :amount_in_usd, :block_hash, :block_height, :blockchain,
                  :contract_address, :create_date, :custody_type,
                  :destination_address, :error_reason, :error_details,
                  :estimated_fee, :fee_level, :first_confirm_date,
                  :network_fee, :network_fee_in_usd, :nfts, :operation,
                  :ref_id, :source_address, :state, :token_id,
                  :transaction_type, :tx_hash, :update_date, :user_id,
                  :wallet_id, :transaction_screening_evaluation

    # @param attributes [Hash] Model attributes
    def initialize(attributes = {})
      attributes = attributes.transform_keys(&:to_sym)

      @id = attributes[:id]
      @abi_function_signature = attributes[:abiFunctionSignature] || attributes[:abi_function_signature]
      @abi_parameters = parse_abi_parameters(attributes[:abiParameters] || attributes[:abi_parameters])
      @amounts = attributes[:amounts]
      @amount_in_usd = attributes[:amountInUSD] || attributes[:amount_in_usd]
      @block_hash = attributes[:blockHash] || attributes[:block_hash]
      @block_height = attributes[:blockHeight] || attributes[:block_height]
      @blockchain = attributes[:blockchain]
      @contract_address = attributes[:contractAddress] || attributes[:contract_address]
      @create_date = parse_datetime(attributes[:createDate] || attributes[:create_date])
      @custody_type = attributes[:custodyType] || attributes[:custody_type]
      @destination_address = attributes[:destinationAddress] || attributes[:destination_address]
      @error_reason = attributes[:errorReason] || attributes[:error_reason]
      @error_details = attributes[:errorDetails] || attributes[:error_details]
      @estimated_fee = parse_transaction_fee(attributes[:estimatedFee] || attributes[:estimated_fee])
      @fee_level = attributes[:feeLevel] || attributes[:fee_level]
      @first_confirm_date = parse_datetime(attributes[:firstConfirmDate] || attributes[:first_confirm_date])
      @network_fee = attributes[:networkFee] || attributes[:network_fee]
      @network_fee_in_usd = attributes[:networkFeeInUSD] || attributes[:network_fee_in_usd]
      @nfts = attributes[:nfts]
      @operation = attributes[:operation]
      @ref_id = attributes[:refId] || attributes[:ref_id]
      @source_address = attributes[:sourceAddress] || attributes[:source_address]
      @state = attributes[:state]
      @token_id = attributes[:tokenId] || attributes[:token_id]
      @transaction_type = attributes[:transactionType] || attributes[:transaction_type]
      @tx_hash = attributes[:txHash] || attributes[:tx_hash]
      @update_date = parse_datetime(attributes[:updateDate] || attributes[:update_date])
      @user_id = attributes[:userId] || attributes[:user_id]
      @wallet_id = attributes[:walletId] || attributes[:wallet_id]
      @transaction_screening_evaluation = parse_screening_decision(
        attributes[:transactionScreeningEvaluation] || attributes[:transaction_screening_evaluation]
      )

      validate!
    end

    private

    def parse_datetime(value)
      return nil if value.nil?
      value.is_a?(Time) ? value : Time.parse(value)
    end

    def parse_abi_parameters(params)
      return nil if params.nil?
      params.map { |param| AbiParametersInner.from_hash(param) }
    end

    def parse_transaction_fee(fee)
      return nil if fee.nil?
      TransactionFee.from_hash(fee)
    end

    def parse_screening_decision(decision)
      return nil if decision.nil?
      TransactionScreeningDecision.from_hash(decision)
    end

    def validate!
      raise ArgumentError, "id is required" if id.nil?
      raise ArgumentError, "blockchain is required" if blockchain.nil?
      raise ArgumentError, "create_date is required" if create_date.nil?
      raise ArgumentError, "state is required" if state.nil?
      raise ArgumentError, "transaction_type is required" if transaction_type.nil?
      raise ArgumentError, "update_date is required" if update_date.nil?
      
      validate_user_id if user_id
      validate_amounts if amounts
    end

    def validate_user_id
      unless user_id.is_a?(String) && user_id.length.between?(5, 50)
        raise ArgumentError, "user_id must be a string between 5 and 50 characters"
      end
    end

    def validate_amounts
      unless amounts.is_a?(Array) && amounts.length >= 1
        raise ArgumentError, "amounts must be an array with at least one element"
      end
    end

    public

    # @return [Hash] Returns the object in the form of hash
    def to_hash
      {
        id: id,
        abiFunctionSignature: abi_function_signature,
        abiParameters: abi_parameters&.map(&:to_hash),
        amounts: amounts,
        amountInUSD: amount_in_usd,
        blockHash: block_hash,
        blockHeight: block_height,
        blockchain: blockchain,
        contractAddress: contract_address,
        createDate: create_date&.iso8601,
        custodyType: custody_type,
        destinationAddress: destination_address,
        errorReason: error_reason,
        errorDetails: error_details,
        estimatedFee: estimated_fee&.to_hash,
        feeLevel: fee_level,
        firstConfirmDate: first_confirm_date&.iso8601,
        networkFee: network_fee,
        networkFeeInUSD: network_fee_in_usd,
        nfts: nfts,
        operation: operation,
        refId: ref_id,
        sourceAddress: source_address,
        state: state,
        tokenId: token_id,
        transactionType: transaction_type,
        txHash: tx_hash,
        updateDate: update_date&.iso8601,
        userId: user_id,
        walletId: wallet_id,
        transactionScreeningEvaluation: transaction_screening_evaluation&.to_hash
      }.compact
    end

    # @return [String] Returns the JSON string representation of the object
    def to_json(*_args)
      to_hash.to_json
    end

    # @param [String] json_string JSON string
    # @return [Transaction] Returns the Transaction instance
    def self.from_json(json_string)
      new(JSON.parse(json_string))
    end

    # @param [Hash] hash The Hash to create an instance from
    # @return [Transaction] Returns the Transaction instance
    def self.from_hash(hash)
      new(hash)
    end

    def to_s
      to_hash.to_s
    end
  end
end