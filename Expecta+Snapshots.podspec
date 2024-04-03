Pod::Spec.new do |s|
  s.name         = 'Expecta+Snapshots'
  s.version      = '3.1.1'
  s.summary      = 'Expecta matchers for taking view snapshots with iOSSnapshotTestCase.'
  s.description  = "Use ios-snapshot-test-case's iOSSnapshotTestCase with Expecta matchers for readability."
  s.homepage     = 'https://github.com/dblock/ios-snapshot-test-case-expecta'
  s.license      = 'MIT'
  s.author       = { 'Daniel Doubrovkine' => "dblock@dblock.org", "orta" => "orta.therox@gmail.com" }
  s.source       = { :git => 'https://github.com/dblock/ios-snapshot-test-case-expecta.git', :tag => s.version.to_s }
  s.platform     = :ios, '10.0'
  s.requires_arc = true
  s.source_files = '*.{h,m}'
  s.frameworks   = 'Foundation', 'XCTest'
  s.dependency     'iOSSnapshotTestCase', '~> 8.0'
  s.dependency     'Expecta', '~> 1.0'
  s.dependency     'Specta', '~> 2.0'
  
  s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
end
