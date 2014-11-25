# -*- encoding: utf-8 -*-
require File.expand_path('../lib/conekta-motion/version.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.name = 'conekta-motion'
  gem.version = ConektaMotion::VERSION
  gem.licenses = ['BSD']
  gem.authors = ['Mario A. Chavez']
  gem.email = ['mario.chavez@gmail.com']
  gem.summary = %{Rubymotion library to use payment gateway Conekta.io}
  gem.description = <<-DESC
 ConektaMotion allows an iOS app to perform payment operations with Conekta.io
  DESC
  gem.homepage = 'https://github.com/mariochavez/conekta-motion'
  gem.files = Dir.glob('lib/**/*.rb')
  gem.files << 'README.md'
  gem.test_files = Dir.glob('spec/**/*.rb')
  gem.require_paths = ['lib']

  gem.add_dependency 'dbt'
  gem.add_dependency 'afmotion'
  gem.add_dependency 'cocoapods', '~> 0.33.1'
  gem.add_dependency 'motion-cocoapods'
end
