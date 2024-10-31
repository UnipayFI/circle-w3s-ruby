module CircleWallets
  module Resources
    class SecurityQuestions
      def initialize(client)
        @client = client
      end

      def list
        @client.get("/v1/w3s/security/questions")
      end

      def set(user_token:, questions:)
        @client.post("/v1/w3s/security/questions", {
          userToken: user_token,
          questions: questions
        })
      end

      def answer(challenge_id:, answers:)
        @client.post("/v1/w3s/security/questions/answers", {
          challengeId: challenge_id,
          answers: answers
        })
      end
    end
  end
end