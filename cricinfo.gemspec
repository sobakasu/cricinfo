# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'cricinfo'

Gem::Specification.new do |s|
  s.name        = "cricinfo"
  s.version     = CricInfo::VERSION
  s.authors     = ["Andrew S Williams"]
  s.email       = ["sobakasu@gmail.com"]
  s.homepage    = "http://github.com/sobakasu/cricinfo"
  s.summary     = %Q{Cricinfo games interface}
  s.description = %Q{Cricinfo games interface}

  s.rubyforge_project = "cricinfo"

  s.files         = `git ls-files | grep -v pkg`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib", "app"]

  # Gem dependencies
  #s.add_dependency("json_pure",  "~> 1.7")
  #s.add_dependency("geokit",     "~> 1.6")
end
