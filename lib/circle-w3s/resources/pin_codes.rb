module CircleW3s
  module Resources
    class PinCodes
      def initialize(client)
        @client = client
      end

      def set(user_token:, pin:)
        @client.post("/v1/w3s/pin", {
          userToken: user_token,
          pin: pin
        })
      end

      def verify(challenge_id:, pin:)
        @client.post("/v1/w3s/pin/verify", {
          challengeId: challenge_id,
          pin: pin
        })
      end
    end
  end
end