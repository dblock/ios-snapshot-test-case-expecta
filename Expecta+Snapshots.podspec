Pod::Spec.new do |s|
  s.name         = 'Expecta+Snapshots'
  s.version      = '3.0.0'
  s.summary      = 'Expecta matchers for taking view snapshots with FBSnapshotTestCase.'
  s.description  = "Use ios-snapshot-test-case's FBSnapshotTest with Expecta matchers for readability."
  s.homepage     = 'https://github.com/dblock/ios-snapshot-test-case-expecta'
  s.license      = 'MIT'
  s.author       = { 'Daniel Doubrovkine' => "dblock@dblock.org", "orta" => "orta.therox@gmail.com" }
  s.source       = { :git => 'https://github.com/dblock/ios-snapshot-test-case-expecta.git', :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = '*.{h,m}'
  s.frameworks   = 'Foundation', 'XCTest'
  s.dependency     'FBSnapshotTestCase/Core', '~> 2.0'
  s.dependency     'Expecta', '~> 1.0'
  s.dependency     'Specta', '~> 1.0'
end
