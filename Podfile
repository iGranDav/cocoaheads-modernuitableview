source 'https://github.com/CocoaPods/Specs.git'

project './CookEat/CookEat.xcodeproj'

use_frameworks!

# Pods shared across all targets
def shared_pods

  # Core
  pod 'Extra', '~> 1.0'
  pod 'Extra/Realm', '~> 1.0'

  # Core
  pod 'RealmSwift', '~> 3.0'
  pod 'RxSwift', '~> 4.0'
  pod 'RxCocoa', '~> 4.0'
  pod 'RxRealm', '~> 0.7.4'

  pod 'SwiftyUserDefaults', '~> 3.0.0'
  pod 'SwiftSoup', '~> 1.6'

  # UI
  pod 'Reusable', '~> 4.0.0'
  pod 'Kingfisher', '~> 4.3'
  
  # Utilities
  pod 'SwiftyBeaver', '~> 1.5'
  pod 'SwiftGen', '~> 5.2.1'
  pod 'SwiftLint', '~> 0.25'
  pod 'Crashlytics', '~> 3.10.1'
  
end

inhibit_all_warnings!

abstract_target 'AppCommon' do

  platform :ios, '10.0'

  shared_pods

#   # Navigation
#   pod 'URLNavigator', '~> 1.2.4'
#   pod 'OneSignal', '~> 2.5.4'

  target 'CookEat' do

  end

end

post_install do |installer|

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.0'
      puts "Disabling code signing for #{target.name} for configuration #{config.name}"
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ''
      config.build_settings['CODE_SIGNING_REQUIRED'] = 'NO'
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      if config.name == 'Release'
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
        else
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
      end
    end
  end

end
