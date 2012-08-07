# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kbb/version'

Gem::Specification.new do |gem|
  gem.name          = "kbb"
  gem.version       = Kbb::VERSION
  gem.authors       = ["Alex Skryl"]
  gem.email         = ["rut216@gmail.com"]
  gem.description   = %q{Kelley Blue Book API Wrapper}
  gem.summary       = %q{A Wrapper for the Kelley Blue Book API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "savon_wsa"
  gem.add_dependency "activesupport"

end
