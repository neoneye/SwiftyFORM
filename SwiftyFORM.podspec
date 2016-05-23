Pod::Spec.new do |s|
  s.name = 'SwiftyFORM'
  s.version = '0.7.0'
  s.license = 'MIT'
  s.summary = 'SwiftyFORM is a form framework for iOS written in Swift'
  s.homepage = 'https://github.com/neoneye/SwiftyFORM'
  s.authors = { 'Simon Strandgaard' => 'simon@iroots.dk' }
  s.source = { :git => 'https://github.com/neoneye/SwiftyFORM.git', :tag => s.version }
  s.source_files = 'Source/*/*.swift'
  s.ios.deployment_target = '8.0'
end