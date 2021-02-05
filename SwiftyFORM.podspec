Pod::Spec.new do |s|
  s.name = 'SwiftyFORM'
  s.version = '1.8.6'
  s.license = 'MIT'
  s.summary = 'SwiftyFORM is an iOS framework for creating forms'
  s.homepage = 'https://github.com/neoneye/SwiftyFORM'
  s.authors = { 'Simon Strandgaard' => 'simon@iroots.dk' }
  s.source = { :git => 'https://github.com/neoneye/SwiftyFORM.git', :tag => s.version }
  s.source_files = 'Source/*/*.swift'
  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
end