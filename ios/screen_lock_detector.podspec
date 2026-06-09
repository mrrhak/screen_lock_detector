#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint screen_lock_detector.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'screen_lock_detector'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin to detect screen lock/unlock events on iOS.'
  s.description      = <<-DESC
A Flutter plugin that enables your app to detect screen lock and unlock events on iOS.
Uses UIApplication notification center APIs to observe protectedData availability changes.
                       DESC
  s.homepage         = 'https://github.com/mrrhak/screen_lock_detector'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mrr Hak' => 'longkimhak.kh@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'screen_lock_detector/Sources/screen_lock_detector/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.resource_bundles = {'screen_lock_detector_privacy' => ['screen_lock_detector/Sources/screen_lock_detector/PrivacyInfo.xcprivacy']}
end
