Pod::Spec.new do |s|
  s.name              = 'Trackingplan'
  s.version           = '0.1.1'
  s.summary           = 'Trackingplan iOS SDK'
  s.homepage          = 'https://github.com/trackingplan/trackingplan-ios'
  s.platform = :ios, '10.0'
  s.license           = {
  :type => 'MIT',
  :file => 'LICENSE'
  }
  s.author            = {
  'Jose Luis Perez' => 'joseleperezgonzalez@trackingplan.com'
  }
  s.source            = {
  :git => 'https://github.com/trackingplan/trackingplan-ios',
  :tag => "#{s.version}" }
  s.requires_arc      = true
  s.source_files = 'Trackingplan/Source/**/*'
  s.dependency 'NetworkInterceptor', '0.0.8'
end
