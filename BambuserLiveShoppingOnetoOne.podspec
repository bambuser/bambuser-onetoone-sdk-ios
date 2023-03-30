Pod::Spec.new do |s|
  s.name                 = "BambuserLiveShoppingOnetoOne"
  s.version              = "1.0.0"
  s.author               = { "Bambuser AB" => "support@bambuser.com" }
  s.homepage             = "https://github.com/bambuser/bambuser-onetoone-sdk-ios"
  s.summary              = "One to One agent tool SDK for iOS"
  s.license              = { :type => "Commercial", :text => "Copyright 2022 Bambuser AB" }
  s.platform             = :ios, "14.3"
  s.source               = { :git => "https://github.com/bambuser/bambuser-onetoone-sdk-ios", :tag => s.version }
  s.vendored_frameworks  = "Sources/BambuserLiveShoppingOnetoOne.xcframework"
end
