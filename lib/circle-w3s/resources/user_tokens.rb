module CircleW3s
  module Resources
    class UserTokens
      def initialize(client)
        @client = client
      end

      def create(user_id:, encryption_key:)
        @client.post("/v1/w3s/users/tokens", {
          userId: user_id,
          encryptionKey: encryption_key
        })
      end
    end
  end
end