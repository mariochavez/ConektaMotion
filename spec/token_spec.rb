describe 'Token' do
  describe 'parse' do
    it 'ok response' do
      response = { id: 'tok_pWv5DipgPvbabidg4', livemode: false, used: false, object: 'token' }

      token = CM::Token.init_from response

      token.valid?.should == true
      token.token_id.should == 'tok_pWv5DipgPvbabidg4'
    end

    it 'error response' do
      response = { type: nil, message_to_purchaser: "The card number is invalid.", object: "error", code: "invalid_number", message: "The card number is invalid.", param: "number" }

      token = CM::Token.init_from response

      token.valid?.should == false
      token.error.should == 'The card number is invalid.'
    end
  end
end
