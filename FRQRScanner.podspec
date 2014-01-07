Pod::Spec.new do |s|
  s.name         = "FRQRScanner"
  s.version      = "0.1.0"
  s.summary      = "A really fast QR scanner using iOS 7's native metadata output"
  s.homepage     = "http://www.fishrod.co.uk"
  s.license      = 'MIT'
  s.author       = { "Gavin Williams" => "gavin.williams@fishrod.co.uk" }
  s.source       = { :git => "https://github.com/fishrod-interactive/frqrscanner.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source_files = 'Classes/FRQRScanner.h,m'
  s.resources = 'Assets'

  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'AVFoundation'
  # s.dependency 'JSONKit', '~> 1.4'
end
