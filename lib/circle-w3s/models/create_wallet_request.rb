module CircleW3s
  class CreateWalletRequest
    attr_accessor :blockchain, :wallet_set_id, :name

    def initialize(blockchain:, wallet_set_id:, name:)
      @blockchain = blockchain
      @wallet_set_id = wallet_set_id
      @name = name
    end
  end
end