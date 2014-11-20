module ConektaMotion
  class Token
    attr_reader :token_id, :error

    def initialize(token_id, error)
      @token_id = token_id
      @error = error
    end

    def valid?
      error.nil?
    end

    class << self
      def init_from(response)
        token_id = nil
        error = nil

        if response
          token_id = response[:id] if response[:object] == 'token'
          error = response[:message_to_purchaser] if response[:object] == 'error'
        end

        Token.new token_id, error
      end
    end
  end
end
