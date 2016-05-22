Pod::Spec.new do |s|
  s.name = 'SwiftyFORM'
  s.version = '0.0.1'
  s.license = 'MIT'
  s.summary = 'SwiftyFORM is a form framework for iOS written in Swift'
  s.homepage = 'https://github.com/Alamofire/Alamofire'
  s.authors = { 'Simon Strandgaard' => 'simon@iroots.dk' }
  s.source = { :git => 'https://github.com/neoneye/SwiftyFORM.git' }

  s.ios.deployment_target = '8.0'
  s.source_files = 'Source/*'
end