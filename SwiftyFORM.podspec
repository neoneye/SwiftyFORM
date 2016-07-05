Pod::Spec.new do |s|
  s.name = 'SwiftyFORM'
  s.version = '0.8.1'
  s.license = 'MIT'
  s.summary = 'SwiftyFORM is a form framework for iOS written in Swift'
  s.homepage = 'https://github.com/bangtoven/SwiftyFORM'
  s.authors = { 'Simon Strandgaard' => 'simon@iroots.dk', "Jungho Bang" => "me@bangtoven.com" }
  s.source = { :git => 'https://github.com/bangtoven/SwiftyFORM.git', :tag => s.version }
  s.source_files = 'Source/*/*.swift'
  s.resources = ['Source/SwiftFORMImages.xcassets']
  s.ios.deployment_target = '8.0'
end