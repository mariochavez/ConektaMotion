class HomeScreen < PM::Screen
  title 'Registrar tarjeta'

  def on_load
    self.view.backgroundColor = UIColor.whiteColor

    self.view.addGestureRecognizer UITapGestureRecognizer.alloc.initWithTarget(self, action: 'hideKeyboard:')

    @number_field = setup_number_field
    @month_field = setup_month_field
    @year_field = setup_year_field
    @cvc_field = setup_cvc_field

    @scan_button = UIButton.buttonWithType(UIButtonTypeRoundedRect).tap do |button|
      button.setTitle 'Escanear tarjeta', forState: UIControlStateNormal
      button.frame = [[50, 125], [200, 50]]

      button.addTarget(self, action: :scan_card_tapped, forControlEvents: UIControlEventTouchUpInside)
    end
    self.view.addSubview @scan_button

    @token_button = UIButton.buttonWithType(UIButtonTypeRoundedRect).tap do |button|
      button.setTitle 'Guardar tarjeta', forState: UIControlStateNormal
      button.frame = [[50, 210], [200, 50]]

      button.addTarget(self, action: :token_card_tapped, forControlEvents: UIControlEventTouchUpInside)
    end
    self.view.addSubview @token_button
  end

  def cardIOView(view, didScanCard:info)
    @number_field.text = info.cardNumber
    @card_io_view.removeFromSuperview
    @card_io_view = nil
  end

  def scan_card_tapped
    dismiss_keyboard
    frame = CGRectMake(30.0, 270.0, 250.0, 250.0)

    @card_io_view = CardIOView.alloc.initWithFrame(frame).tap do |card|
      card.languageOrLocale = 'es_MX'
      card.guideColor = UIColor.whiteColor
      card.useCardIOLogo = true
      card.delegate = self
    end

    self.view.addSubview @card_io_view
  end

  def token_card_tapped
    dismiss_keyboard
    show_spinner

    card = CM::Card.new @number_field.text.to_s, 'Sample User',
      @cvc_field.text.to_s, @month_field.text.to_s, @year_field.text.to_s

    if card.valid?
      conekta = CM::Conekta.new

      conekta.tokenize_card card do |token|
        if token.valid?
          alert('Operación completa',
                "Su tarjeta #{card.brand.to_s} #{card.last_four} fue registrada correctamente. #{token.token_id}", 'Ok')
        else
          alert('Operación con error', "Su tarjerta #{card.last_four} no pudo ser registrada")
        end

        hide_spinner
      end
    else
      hide_spinner
      alert('Datos incompletos', 'Llene todos los datos de la forma.')
    end
  end

  def textFieldShouldReturn(field)
    if field == @number_field
      @month_field.becomeFirstResponder
    elsif field == @month_field
      @year_field.becomeFirstResponder
    elsif field == @year_field
      @cvc_field.becomeFirstResponder
    else
      field.resignFirstResponder
    end

    true
  end

  private
  def show_spinner
    SVProgressHUD.showWithMaskType SVProgressHUDMaskTypeBlack
  end

  def hide_spinner
    SVProgressHUD.dismiss
  end

  def alert(title, message, cancel = 'Cancel')
    UIAlertView.alloc.initWithTitle(title, message: message, delegate: self,
                                    cancelButtonTitle: cancel, otherButtonTitles: nil).show
  end

  def setup_number_field
    setup_field [[10, 90], [300, 40]], 'Número de tarjeta de crédito'
  end

  def setup_month_field
    setup_field [[10, 170], [80, 40]], 'Mes'
  end

  def setup_year_field
    setup_field [[100, 170], [80, 40]], 'Año'
  end

  def setup_cvc_field
    setup_field [[190, 170], [80, 40]], 'CVC'
  end

  def setup_field(frame, placeholder)
    field = UITextField.alloc.initWithFrame(frame).tap do |input|
      input.placeholder = placeholder
      input.keyboardType = UIKeyboardTypeNumberPad
      input.borderStyle =  UITextBorderStyleLine
      input.returnKeyType = UIReturnKeyNext
      input.delegate = self
    end

    self.view.addSubview field
    field
  end

  def hideKeyboard(sender)
    dismiss_keyboard
  end

  def dismiss_keyboard
    @number_field.resignFirstResponder
    @month_field.resignFirstResponder
    @year_field.resignFirstResponder
    @cvc_field.resignFirstResponder

    @card_io_view.removeFromSuperview if @card_io_view
  end
end
