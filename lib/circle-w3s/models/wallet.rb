module CircleW3s
  class Wallet
    attr_accessor :id, :address, :blockchain, :create_date, :update_date,
                  :custody_type, :name, :ref_id, :state, :user_id, :wallet_set_id

    # @param attributes [Hash] Model attributes in the form of hash
    def initialize(attributes = {})
      # Convert keys to symbols
      attributes = attributes.transform_keys(&:to_sym)

      @id = attributes[:id]
      @address = attributes[:address]
      @blockchain = attributes[:blockchain]
      @create_date = attributes[:createDate] || attributes[:create_date]
      @update_date = attributes[:updateDate] || attributes[:update_date]
      @custody_type = attributes[:custodyType] || attributes[:custody_type]
      @name = attributes[:name]
      @ref_id = attributes[:refId] || attributes[:ref_id]
      @state = attributes[:state]
      @user_id = attributes[:userId] || attributes[:user_id]
      @wallet_set_id = attributes[:walletSetId] || attributes[:wallet_set_id]

      validate!
    end

    # Validates the required properties
    # @raise [ArgumentError] if required properties are missing
    def validate!
      raise ArgumentError, "id is required" if id.nil?
      raise ArgumentError, "address is required" if address.nil?
      raise ArgumentError, "blockchain is required" if blockchain.nil?
      raise ArgumentError, "create_date is required" if create_date.nil?
      raise ArgumentError, "update_date is required" if update_date.nil?
      raise ArgumentError, "custody_type is required" if custody_type.nil?
      raise ArgumentError, "state is required" if state.nil?
      raise ArgumentError, "wallet_set_id is required" if wallet_set_id.nil?
      
      validate_user_id if user_id
    end

    # Validates user_id format
    def validate_user_id
      unless user_id.is_a?(String) && user_id.length.between?(5, 50)
        raise ArgumentError, "user_id must be a string between 5 and 50 characters"
      end
    end

    # Convert to JSON string
    # @return [String] JSON string representation of the object
    def to_json(*_args)
      to_hash.to_json
    end

    # Convert to Hash
    # @return [Hash] Returns the object in the form of hash
    def to_hash
      {
        id: id,
        address: address,
        blockchain: blockchain,
        createDate: create_date,
        updateDate: update_date,
        custodyType: custody_type,
        name: name,
        refId: ref_id,
        state: state,
        userId: user_id,
        walletSetId: wallet_set_id
      }.compact
    end

    # Creates an instance of Wallet from a JSON string
    # @param [String] json_string JSON string
    # @return [Wallet] Instance of Wallet
    def self.from_json(json_string)
      new(JSON.parse(json_string))
    end

    # Creates an instance of Wallet from a Hash
    # @param [Hash] hash Hash containing attributes
    # @return [Wallet] Instance of Wallet
    def self.from_hash(hash)
      new(hash)
    end

    # Returns string representation of the object
    # @return [String] String representation of the object
    def to_s
      to_hash.to_s
    end
  end
end