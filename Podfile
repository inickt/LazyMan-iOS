workspace 'LazyMan'

project 'LazyMan-iOS'
project 'LazyManCore'

# Pods for LazyManCore
abstract_target 'core' do
  project 'LazyManCore'
  use_frameworks!

  pod 'Pantomime', :git => 'https://github.com/inickt/Pantomime.git', :branch => 'master', :inhibit_warnings => true

  target 'LazyManCore-iOS' do
		platform :ios, '9.0'
	end

	target 'LazyManCore-tvOS' do
	  platform :tvos, '9.0'
	end

	target 'LazyManCore-macOS' do
	  platform :macos, '10.12'
	end
end

# Pods for LazyMan-iOS
target 'LazyMan-iOS' do
	project 'LazyMan-iOS'
  platform :ios, '9.0'
  use_frameworks!

  pod 'FSCalendar', '2.7.9', :inhibit_warnings => true
  pod 'Pantomime', :git => 'https://github.com/inickt/Pantomime.git', :branch => 'master', :inhibit_warnings => true
  pod 'OptionSelector', '~> 0.2'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'google-cast-sdk'
end

