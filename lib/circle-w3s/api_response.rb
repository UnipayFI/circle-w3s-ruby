module CircleW3s
  class ApiResponse
    attr_reader :data, :code, :headers

    def initialize(data:, code:, headers:)
      @data = data
      @code = code
      @headers = headers
    end
  end
end