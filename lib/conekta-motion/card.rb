module ConektaMotion
  class Card
    attr_accessor :number, :name, :cvc, :expiration_month,
      :expiration_year
    attr_reader :errors

    def initialize(number = nil, name = nil, cvc = nil,
                   expiration_month = nil, expiration_year = nil)
      self.number = number
      self.name = name
      self.cvc = cvc
      self.expiration_month = expiration_month
      self.expiration_year = expiration_year

      @errors = {}
    end

    def to_json
      <<_JSON_
      {"card:" {
        "name:" "#{name.to_s}",
        "number:" "#{clean_number.to_s}",
        "cvc:" "#{cvc.to_s}",
        "exp_month:" "#{expiration_month.to_s}",
        "exp_year:" "#{expiration_year.to_s}"
        }
      }
_JSON_
    end

    def valid?
      @errors = {}

      @errors[:number] = 'Número de tarjeta inválida' if brand.nil? || !valid_card?

      @errors[:name] = 'Nombre de tarjetahabiente inválido' if name.nil? || name.empty?

      @errors[:cvc] = 'Código de seguridad inválido' if !valid_cvc?

      @errors[:expiration_month] = 'Mes de expiración inválido' if !valid_expiration_month?

      @errors[:expiration_year] = 'Año de expiración inválido' if !valid_expiration_year?

      @errors.keys.count == 0
    end

    def brand
      _number = clean_number

      return :dinners if _number.length == 14 && _number =~ /^3(0[0-5]|[68])/ # 300xxx-305xxx, 36xxxx, 38xxxx
      return :amex if _number.length == 15 && _number =~ /^3[47]/ # 34xxxx, 37xxxx
      return :visa if [13,16].include?(_number.length) && _number =~ /^4/ # 4xxxxx
      return :master if _number.length == 16 && _number =~ /^5[1-5]/ # 51xxxx-55xxxx
      return :discover if _number.length == 16 && _number =~ /^6011/ # 6011xx
      nil
    end

    private
    def clean_number
      return '' if number.nil?
      number.gsub(/\D/, '')
    end

    def valid_card?
      reversed_number = clean_number.reverse

      relative_number = {'0' => 0, '1' => 2, '2' => 4, '3' => 6, '4' => 8, '5' => 1, '6' => 3, '7' => 5, '8' => 7, '9' => 9}

      accumulator = 0

      reversed_number.split('').each_with_index do |digit, index|
        accumulator += (index % 2 == 0) ? digit.to_i : relative_number[digit]
      end

      accumulator % 10 == 0
    end

    def valid_cvc?
      return false if cvc.nil? || !(cvc =~ /^\d{3,4}/) || !(3..4).include?(cvc.length)
      true
    end

    def valid_expiration_month?
      return false if expiration_month.nil? || !(expiration_month =~ /^\d{2}/) || expiration_month.length != 2 || !(1..12).include?(expiration_month.to_i)
      true
    end

    def valid_expiration_year?
      return false if expiration_year.nil? || !(expiration_year =~ /^\d{2}/) || expiration_year.length != 2 || !(expiration_year.to_i > 0)
      true
    end
  end
end
