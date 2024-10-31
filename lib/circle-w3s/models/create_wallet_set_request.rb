require 'securerandom'

module CircleW3s
  class CreateWalletSetRequest
    attr_accessor :name, :idempotency_key, :entity_secret_ciphertext

    def initialize(name:, entity_secret_ciphertext: nil, idempotency_key: nil)
      @name = name
      @entity_secret_ciphertext = entity_secret_ciphertext
      
      @idempotency_key = idempotency_key || SecureRandom.uuid
    end

    def to_json(*_args)
      {
        name: @name,
        idempotencyKey: @idempotency_key,
        entitySecretCiphertext: @entity_secret_ciphertext
      }.compact.to_json
    end
  end
end