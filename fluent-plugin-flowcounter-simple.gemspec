# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name        = "fluent-plugin-flowcounter-simple"
  gem.version     = "0.0.1"
  gem.authors     = ["Naotoshi Seo"]
  gem.email       = ["sonots@gmail.com"]
  gem.summary     = %q{Simple Fluentd Plugin to count number of messages and outputs to log}
  gem.description = %q{Simple Fluentd Plugin to count number of messages and outputs to log}
  gem.homepage    = "https://github.com/sonots/fluent-plugin-flowcounter-simple"
  gem.license     = "MIT"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"
  gem.add_runtime_dependency "fluentd"
end
