Pod::Spec.new do |s|
  s.name              = 'Trackingplan'
  s.version           = '1.0.21'
  s.summary           = 'Trackingplan iOS SDK'
  s.homepage          = 'https://github.com/trackingplan/trackingplan-ios'
  s.platform = :ios, '12.0'
  s.license           = {
  :type => 'MIT',
  :file => 'LICENSE'
  }
  s.author            = {
  'Trackingplan Inc' => 'team@trackingplan.com'
  }
  s.source            = {
  :git => 'https://github.com/trackingplan/trackingplan-ios.git',
  :tag => "#{s.version}" }
  s.requires_arc      = true
  s.source_files = 'Trackingplan/Sources/**/*'
end
