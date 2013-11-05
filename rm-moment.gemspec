# -*- encoding: utf-8 -*-
VERSION = "0.0.1"

Gem::Specification.new do |spec|
  spec.name          = "rm-moment"
  spec.version       = VERSION
  spec.authors       = ["Steve Ross"]
  spec.email         = ["sxross@gmail.com"]
  spec.description   = %q{Wraps NSMoment Cocoapod}
  spec.summary       = %q{More idiomatic Ruby wrappers for NSMoment Cocoapod which is inspired by MomentJS. This handles a number of date/time related chores.}
  spec.homepage      = ""
  spec.license       = ""

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency ""
end
