#
#   Created by : Nghia Tran
#   Sun, 25th Sept 2016, Vietnam
#

source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

# Test
def test_pods
    pod 'Quick', '~> 0.10.0'
    pod 'Nimble', '~> 5.0.0'
end

# Titan Kit Test
target "Swifty-PostgreSQLTests" do
    platform :osx, '10.12'
    test_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.12'
    end
  end
end
