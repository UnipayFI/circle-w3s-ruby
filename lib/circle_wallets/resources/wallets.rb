module CircleWallets
  module Resources
    class Wallets
      def initialize(client)
        @client = client
      end

      def create(user_token:)
        @client.post("/v1/w3s/wallet", { userToken: user_token })
      end

      def list(user_token:)
        @client.get("/v1/w3s/wallets", { userToken: user_token })
      end

      def get(wallet_id:)
        @client.get("/v1/w3s/wallet/#{wallet_id}")
      end

      def get_balance(wallet_id:, token_id: nil)
        path = "/v1/w3s/wallet/#{wallet_id}/balances"
        path += "/#{token_id}" if token_id
        @client.get(path)
      end
    end
  end
end