module CircleW3s
  module Resources
    class ChallengeIds
      def initialize(client)
        @client = client
      end

      def create(user_token:)
        @client.post("/v1/w3s/challenges", { userToken: user_token })
      end

      def get(challenge_id:)
        @client.get("/v1/w3s/challenges/#{challenge_id}")
      end
    end
  end
end