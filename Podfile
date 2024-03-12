$version = '13.4'
platform :ios, $version
source 'https://github.com/CocoaPods/Specs.git'
inhibit_all_warnings!

target 'Tracker' do
  pod 'SwiftGen'
  pod 'YandexMobileMetrica'
end

post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          project.build_settings(config.name)["IPHONEOS_DEPLOYMENT_TARGET"] = $version
          config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = $version
        end
      end
    end
end