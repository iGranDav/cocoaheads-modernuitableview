source 'https://github.com/CocoaPods/Specs.git'

project './DemoTableView/DemoTableView.xcodeproj'

use_frameworks!

# Pods shared across all targets
def shared_pods

  # Core
  pod 'RealmSwift', '~> 3.0'

  pod 'SwiftyUserDefaults', '~> 3.0.0'
  pod 'SwiftDate', '~> 4.5.1'
  
  # Utilities
  pod 'SwiftyBeaver', '~> 1.5'
  pod 'SwiftGen', '~> 5.2.1'
  pod 'SwiftLint', '~> 0.25'
  
end

inhibit_all_warnings!

abstract_target 'AppCommon' do

  platform :ios, '10.0'

  shared_pods

#   # Navigation
#   pod 'URLNavigator', '~> 1.2.4'
#   pod 'OneSignal', '~> 2.5.4'

  target 'DemoTableViewCore' do

    # Core
    pod 'Extra/Foundation', '~> 1.0'
    pod 'Extra/Realm', '~> 1.0'
  end

  target 'DemoTableView' do

    # UI
    pod 'Extra/UIKit', '~> 1.0'
    pod 'Reusable', '~> 4.0.0'
    pod 'Kingfisher', '~> 4.3'

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
