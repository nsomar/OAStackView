Pod::Spec.new do |s|
  s.name             = "OAStackView"
  s.version          = "1.0.1"
  s.summary          = "Porting UIStackView to iOS 7+."
  s.description      = <<-DESC
  iOS 9 introduced the very cool [UIStackView](https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIStackView_Class_Reference/), UIStackView can be used to easily create simple and complex layouts.

  As expected `UIStackView` can only be used for iOS9 and up. This project tries to port back the stackview to iOS 6+.
                       DESC
  s.homepage         = "https://github.com/oarrabi/OAStackView"
  s.license          = 'MIT'
  s.author           = { "Omar Abdelhafith" => "o.arrabi@me.com" }
  s.source           = { :git => "https://github.com/oarrabi/OAStackView.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

end
