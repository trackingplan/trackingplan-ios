Pod::Spec.new do |s|
  s.name              = 'Trackingplan'
  s.version           = '1.6.1'
  s.summary           = 'Trackingplan iOS SDK'
  s.homepage          = 'https://github.com/trackingplan/trackingplan-ios'
  s.platform          = :ios, '12.0'
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.license           = {
    :type => 'Copyright',
    :text => 'Copyright © Trackingplan. All rights reserved. Private license.'
  }
  s.author            = {
  'Trackingplan Inc' => 'team@trackingplan.com'
  }
  s.source            = {
  :git => 'https://github.com/trackingplan/trackingplan-ios.git',
  :tag => "#{s.version}" }
  s.requires_arc      = true
  s.source_files = 'Sources/Trackingplan/**/*'
  s.vendored_frameworks = 'Frameworks/TrackingplanShared.xcframework'

end
