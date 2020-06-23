# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'c2c' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for c2c
pod 'Firebase/Core'
pod 'Firebase/Database'
pod 'Firebase/Auth'
pod 'GoogleSignIn'
pod 'ChirpSDK'
pod 'SwiftyJSON'
pod 'Firebase/Messaging'
pod 'Kingfisher'
end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
        end
    end
end

