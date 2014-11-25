describe 'Card' do
  before do
    @card = ConektaMotion::Card.new
  end

  describe 'card properties' do
    it 'accepts card number' do
      card = CM::Card.new '4242 4242 4242 4242'

      card.number.should == '4242 4242 4242 4242'
    end

    it 'accepts card holder name' do
      card = CM::Card.new '4242 4242 4242 4242',
        'Juan Perez'

      card.name.should == 'Juan Perez'
    end

    it 'accepts CVC code' do
      card = CM::Card.new '4242 4242 4242 4242',
        'Juan Perez', '001'

      card.cvc.should == '001'
    end

    it 'accepts expiration month' do
      card = CM::Card.new '4242 4242 4242 4242',
        'Juan Perez', '001', '01'

      card.expiration_month.should == '01'
    end

    it 'accepts expiration year' do
      card = CM::Card.new '4242 4242 4242 4242',
        'Juan Perez', '001', '01', '14'

      card.expiration_year.should == '14'
    end
  end

  describe 'card validation' do
    describe 'card number' do
      it 'is valid' do
        @card.number = '4242 4242 4242 4242'
        @card.valid?

        @card.errors.has_key?(:number).should == false
      end

      it 'is invalid due wrong number' do
        @card.number = '8242 4242'
        @card.valid?

        @card.errors.has_key?(:number).should == true
        @card.errors[:number].should == 'Número de tarjeta inválida'
      end

      it 'is invalid due do not pass lunh validation' do
        @card.number = '4242 4242 4242 8282'
        @card.valid?

        @card.errors.has_key?(:number).should == true
        @card.errors[:number].should == 'Número de tarjeta inválida'
      end
    end

    describe 'holder name' do
      it 'is valid' do
        @card.name = 'Juan Perez'
        @card.valid?

        @card.errors.has_key?(:name).should == false
      end

      it 'is invalid' do
        @card.name = ''
        @card.valid?

        @card.errors.has_key?(:name).should == true
        @card.errors[:name].should == 'Nombre de tarjetahabiente inválido'
      end
    end

    describe 'cvc' do
      it 'is valid' do
        @card.cvc = '090'
        @card.valid?

        @card.errors.has_key?(:cvc).should == false
      end

      it 'is invalid if empty' do
        @card.cvc = nil
        @card.valid?

        @card.errors.has_key?(:cvc).should == true
        @card.errors[:cvc].should == 'Código de seguridad inválido'
      end

      it 'is invalid wrong number ' do
        @card.cvc = '90'
        @card.valid?

        @card.errors.has_key?(:cvc).should == true
        @card.errors[:cvc].should == 'Código de seguridad inválido'
      end
    end
  end

  describe 'expiration month' do
    it 'is valid' do
      @card.expiration_month = '01'
      @card.valid?

      @card.errors.has_key?(:expiration_month).should == false
    end

    it 'is invalid wrong value' do
      @card.expiration_month = 'a1'
      @card.valid?

      @card.errors.has_key?(:expiration_month).should == true
      @card.errors[:expiration_month].should == 'Mes de expiración inválido'
    end

    it 'is invalid when wrong month number' do
      @card.expiration_month = '13'
      @card.valid?

      @card.errors.has_key?(:expiration_month).should == true
      @card.errors[:expiration_month].should == 'Mes de expiración inválido'
    end
  end

  describe 'expiration year' do
    it 'is valid' do
      @card.expiration_year = '17'
      @card.valid?

      @card.errors.has_key?(:expiration_year).should == false
    end

    it 'is invalid wrong value' do
      @card.expiration_year = '1b'
      @card.valid?

      @card.errors.has_key?(:expiration_year).should == true
      @card.errors[:expiration_year].should == 'Año de expiración inválido'
    end
  end

  describe 'card brand' do
    it 'detects visa cards' do
      @card.number = '4035330730728765'

      @card.brand.should == :visa
    end

    it 'detects mastercard cards' do
      @card.number = '5352081557347062'

      @card.brand.should == :master
    end

    it 'detects amex cards' do
      @card.number = '342411430263950'

      @card.brand.should == :amex
    end

    it 'detects dinners cards' do
      @card.number = '38520000023237'

      @card.brand.should == :dinners
    end

    it 'detects discover cards' do
      @card.number = '6011111111111117'

      @card.brand.should == :discover
    end
  end

  describe '#to_hash' do
    it 'serialize card data' do
      @card.number = '4242 4242 4242 4242'
      @card.name = 'Juan Perez'
      @card.cvc = '090'
      @card.expiration_month = '02'
      @card.expiration_year = '18'

      @card.to_hash.should == { card:
        {
          name: "Juan Perez",
          number: "4242424242424242",
          cvc: "090",
          exp_month: "02",
          exp_year: "18"
        }
      }
    end
  end

  describe '#last_four' do
    it 'returns card number last four digits' do
      @card.number = '4242 4242 4242 4242'

      @card.last_four.should == '4242'
    end
  end
end
