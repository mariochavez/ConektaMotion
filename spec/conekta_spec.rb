describe 'Conekta' do
  extend WebStub::SpecHelpers

  before do
    disable_network_access!
    @conekta = ConektaMotion::Conekta.new 'key_DzVhxySdJAfmboDePSVUCuQ'
  end

  context '#tokenize' do
    it 'should tokenize a valid card' do
      stub_request(:post, 'https://api.conekta.io/tokens').
        to_return(json: { id: 'tok_pWv5DipgPvbabidg4', livemode: false, used: false, object: 'token' })

      card = CM::Card.new '4242 4242 4242 4242', 'Juan Perez',
        '090', '02', '18'

      @conekta.tokenize_card card do |token|
        @token = token
        resume
      end

      wait_max 1.0 do
        @token.nil?.should == false
        @token.valid?.should == true
      end
    end
  end
end
