# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blackjack/version'

Gem::Specification.new do |spec|
  spec.name          = 'blackjack_game'
  spec.version       = Blackjack::VERSION
  spec.authors       = ['Cyril Sadovnik']
  spec.email         = ['cyril.sadovnik@gmail.com']

  spec.summary       = 'Simple CLI Blackjack'
  spec.homepage      = 'https://github.com/sadovnik/blackjack'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'tty-prompt', '~> 0.12'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
