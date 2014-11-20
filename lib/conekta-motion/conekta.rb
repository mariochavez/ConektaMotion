module ConektaMotion
  class Conekta
    def initialize(api_key = API_KEY)
      @api_key = api_key
    end

    def tokenize_card(card, &block)
      web_client.post('/tokens', card.to_hash) do |response|
        token = nil

        if response.failure?
          unless response.error.is_a?(NSURLError)
            token = Token.init_from response.object
          end
        else
          token = Token.init_from response.object
        end

        block.call token
      end
    end

    private
    def encoded_api_key
      [@api_key].pack("m0")
    end

    def web_client
      key = encoded_api_key

      @@web_client ||= begin
        AFMotion::Client.build('https://api.conekta.io') do
          request_serializer :json
          response_serializer :json

          header 'Content-type', 'application/json'
          header 'Accept', 'application/vnd.conekta-v0.3.0+json'
          header 'Authorization', "Basic #{key}"
          header 'Conekta-Client-User-Agent', '{"agent": "Conekta Conekta iOS SDK"}' #'ConektaMotion iOS', seems that Conekta only accepts this agent.
        end
      end
    end
  end
end
