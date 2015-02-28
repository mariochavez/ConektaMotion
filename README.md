# ConektaMotion
A Rubymotion gem to help you to tokenize a Bank Card with mexican payment gateway Conekta. This gem is intended to be used with Rubymotion.

## Install

1. `gem install conekta-motion`

2. `require 'conekta-motion'` or add to your Gemfile (`gem 'conekta-motion'`)

## Usage
`ConektaMotion::Card` object helps you to collect Bank Card information and perform basic validations before any is sent via `SSL` to Conekta.io.

    card = CM::Card.new '4242 4242 4242 4242', 'Juan Perez', '090', '02', '18'

All arguments for `Card` need to be `string`. Arguments on `Card` initialization are: number, name, cvc, expiration_month and expiration_year.

`Card` has a `#valid?` method that returns true or false base on Bank Card info validation. Validations at this point are related to have required arguments and card number to pass [Luhn algorithm](http://en.wikipedia.org/wiki/Luhn_algorithm).

    card.valid?
    => false

If card validation failed then `Card`'s method `#error` will have detailed information on what is the problem. `#error` returns a `Hash`.

In order to send Bank Card information to Conekta.io and get a token that represent that card you must use `ConektaMotion::Conekta` object.

    conekta = CM:Conekta.new API_KEY # this constant needs to be set with Conekta.io API's key.
    conekta.tokenize_card card do |token|
      @token = token
    end
  
`token` is an object from class `ConektaMotion::Token`. If card was tokenized correctly then `#token_id` will have the token returned by Conekta.io. If tokenization failed, you must check `#error` to get the message returned by Conekta.io

    conekta.tokenize_card card do |token|
      if token.valid?
        puts "This is your token: #{token.token_id}"
      esle
        puts "We have an error: #{token.error}
      end
    end

## Sample project
A sample project is included in sample directory.

## Bugs and feedback
Use issues at Github to report bugs or give feedback.

Copyright © 2015 Mario Alberto Chávez. This project uses MIT-LICENSE.
