#
# Be sure to run `pod lib lint FZValidationTextField.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "FZValidationTextField"
  s.version          = "0.1.0"
  s.summary          = "UITextField Validation class which will help you in form validations"
  s.description      = "UITextField Validation class which will help you in form validations, field validations, plug and play component just set the class and define validation type and it will validate automatically."
  s.homepage         = "https://github.com/faheemziker/FZValidationTextField"
  s.screenshots     =  ["http://image.yogile.com/yz4btnpu/sevgtycxayd3p801nhd5pa-large.png", "www.example.com/screenshots_2"]
  s.license          = 'MIT'
  s.author           = { "Faheem" => "faheemzikeria@gmail.com" }
  s.source           = { :git => "https://github.com/faheemziker/FZValidationTextField.git", :tag => s.version.to_s }
  s.social_media_url = 'https://www.facebook.com/Faheem.Zikeria'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'FZValidationTextField' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
