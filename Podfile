# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'Couchsurfers' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Couchsurfers

  # add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'

  # add the Firebase pod for Firebase Authentication
  pod 'Firebase/Auth'

  # Alamofire
  pod 'Alamofire'

  # Facebook
  pod 'FBSDKLoginKit'
  pod 'FBSDKCoreKit'

  post_install do |pi|
       pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
        end
      end
  end

end
