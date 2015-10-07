Pod::Spec.new do |s|
  s.name         = "KYDrawerController"
  s.version      = "1.1.1"
  s.summary      = "KYDrawerController is a side drawer navigation container view controller."
  s.homepage     = "https://github.com/ykyouhei/KYDrawerController"
  s.license      = "MIT"
  s.author       = { "Kyohei Yamaguchi" => "kyouhei.lab@gmail.com" }
  s.social_media_url   = "https://twitter.com/kyo__hei"
  s.platform     = :ios
  s.source       = { :git => "https://github.com/ykyouhei/KYDrawerController.git", :tag => s.version.to_s }
  s.source_files = "Classes/*.swift"
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
end
