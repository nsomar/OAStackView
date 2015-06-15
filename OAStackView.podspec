#
# Be sure to run `pod lib lint OAStackView.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "OAStackView"
  s.version          = "0.1.0"
  s.summary          = "Porting UIStackView to iOS 7+."
  s.description      = <<-DESC
  iOS 9 introduced the very cool [UIStackView](https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIStackView_Class_Reference/), UIStackView can be used to easily create simple and complex layouts.

  As expected `UIStackView` can only be used for iOS9 and up. This project tries to port back the stackview to iOS 6+.
                       DESC
  s.homepage         = "https://github.com/oarrabi/OAStackView"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Omar Abdelhafith" => "o.arrabi@me.com" }
  s.source           = { :git => "https://github.com/oarrabi/OAStackView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'OAStackView' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
