module CircleW3s
  module Errors
    class ApiError < StandardError
      attr_reader :code, :response

      def initialize(code: nil, message: nil, response: nil)
        @code = code || response&.status
        @response = response
        @message = message || parse_error_message
        
        super(@message)
      end

      private

      def parse_error_message
        return "API request failed" unless @response
        
        if @response.body.is_a?(Hash)
          @response.body["message"] || @response.body["error"] || "Unknown error"
        else
          @response.body.to_s
        end
      end
    end
  end
end