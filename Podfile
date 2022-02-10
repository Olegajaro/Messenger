# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
  end
 end
end

target 'Messenger' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Messenger
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'FirebaseFirestoreSwift'

  pod 'Gallery'
  pod 'RealmSwift'

  #pod 'ProgressHUD'  
  pod 'SKPhotoBrowser'

  pod 'MessageKit'
  pod 'InputBarAccessoryView'

end
