module CircleWallets
  module Resources
    class Transactions
      def initialize(client)
        @client = client
      end

      def create(params = {})
        @client.post("/v1/w3s/transactions", params)
      end

      def list(params = {})
        @client.get("/v1/w3s/transactions", params)
      end

      def get(transaction_id:)
        @client.get("/v1/w3s/transactions/#{transaction_id}")
      end

      def estimate_fee(params = {})
        @client.post("/v1/w3s/transactions/fees", params)
      end

      def validate(params = {})
        @client.post("/v1/w3s/transactions/validate", params)
      end
    end
  end
end