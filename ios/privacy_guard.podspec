#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint privacy_guard.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'privacy_guard'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter privacy protection SDK.'
  s.description      = <<-DESC
Protect sensitive Flutter screens with screenshot prevention, recording detection, and app switcher blur.
                       DESC
  s.homepage         = 'https://pub.dev/packages/privacy_guard'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Privacy Guard Team' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform         = :ios, '12.0'
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
  }
  s.swift_version    = '5.0'
end
