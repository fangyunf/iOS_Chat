# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'ShenWU' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

#  pod 'AFNetworking'
  pod 'YYKit'
  pod 'SDCycleScrollView', '1.80'
  pod 'CYLTabBarController'
  pod 'Masonry'
  pod 'MJRefresh'
  pod 'SDWebImage'
  pod 'SCIndexView'
  pod 'NTESVerifyCode'
  pod 'FLAnimatedImage'
  
  pod 'NEContactUIKit', :path => 'NEContactUIKit/NEContactUIKit.podspec'
  pod 'NEConversationUIKit', :path => 'NEConversationUIKit/NEConversationUIKit.podspec'
  pod 'NETeamUIKit', :path => 'NETeamUIKit/NETeamUIKit.podspec'
  pod 'NEChatUIKit', :path => 'NEChatUIKit/NEChatUIKit.podspec'
  pod 'NEMapKit', :path => 'NEMapKit/NEMapKit.podspec'

  #基础kit库
  pod 'NECoreKit', '9.6.6'
  pod 'NECoreIMKit', '9.6.7'
  pod 'NECommonKit', '9.6.6'
  pod 'NECommonUIKit', '9.6.7'
  pod 'NEChatKit', '9.7.0'
  
#  pod 'SVProgressHUD'
  pod "Popover"
  pod 'IQKeyboardManager'
  pod 'JXPagingView/Pager'
  pod 'JXCategoryView'
  
  pod 'AvoidCrash'
  
  #支付宝支付
  pod  'AlipaySDK-iOS', '15.8.16'

  target 'ShenWUTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ShenWUUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
      end
  end
  
  bitcode_strip_path = `xcrun --find bitcode_strip`.chop!
    def strip_bitcode_from_framework(bitcode_strip_path, framework_relative_path)
      framework_path = File.join(Dir.pwd, framework_relative_path)
      command = "#{bitcode_strip_path} #{framework_path} -r -o #{framework_path}"
      puts "Stripping bitcode: #{command}"
      system(command)
    end
    framework_paths = [
      "/Pods/YXAlog/YXAlog_iOS.framework/YXAlog_iOS",
    ]
    framework_paths.each do |framework_relative_path|
      strip_bitcode_from_framework(bitcode_strip_path, framework_relative_path)
    end
end
