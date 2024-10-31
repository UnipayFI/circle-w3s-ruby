module CircleW3s
  class WalletSet
    attr_accessor :id, :create_date, :update_date

    # Initialize a new WalletSet instance
    # @param attributes [Hash] Model attributes in the form of hash
    def initialize(attributes = {})
      # Convert keys to symbols
      attributes = attributes.transform_keys(&:to_sym)

      @id = attributes[:id]
      @create_date = parse_datetime(attributes[:createDate] || attributes[:create_date])
      @update_date = parse_datetime(attributes[:updateDate] || attributes[:update_date])

      validate!
    end

    private

    def parse_datetime(value)
      return nil if value.nil?
      value.is_a?(Time) ? value : Time.parse(value)
    end

    def validate!
      raise ArgumentError, "id is required" if id.nil?
      raise ArgumentError, "create_date is required" if create_date.nil?
      raise ArgumentError, "update_date is required" if update_date.nil?
    end

    public

    # Convert instance to JSON string
    # @return [String] JSON string representation of the object
    def to_json(*_args)
      to_hash.to_json
    end

    # Convert instance to Hash
    # @return [Hash] Returns the object in the form of hash
    def to_hash
      {
        id: id,
        createDate: create_date&.iso8601,
        updateDate: update_date&.iso8601
      }.compact
    end

    # Create an instance of WalletSet from a JSON string
    # @param [String] json_string JSON string
    # @return [WalletSet] Instance of WalletSet
    def self.from_json(json_string)
      new(JSON.parse(json_string))
    end

    # Create an instance of WalletSet from a Hash
    # @param [Hash] hash Hash containing attributes
    # @return [WalletSet] Instance of WalletSet
    def self.from_hash(hash)
      new(hash)
    end

    # String representation of the object
    # @return [String] String representation of the object
    def to_s
      to_hash.to_s
    end
  end
end