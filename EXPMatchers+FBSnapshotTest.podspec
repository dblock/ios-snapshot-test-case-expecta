Pod::Spec.new do |s|
  s.name         = 'EXPMatchers+FBSnapshotTest'
  s.version      = '1.0'
  s.summary      = 'Expecta matchers for ios-snapshot-test-case.'
  s.description  = "Use ios-snapshot-test-case's FBSnapshotTest with Specta/Expecta."
  s.homepage     = 'https://github.com/dblock/ios-snapshot-test-case-expecta'
  s.license      = 'MIT'
  s.author       = 'Daniel Doubrovkine'
  s.source       = { :git => 'https://github.com/dblock/ios-snapshot-test-case-expecta.git', :tag => s.version.to_s }
  s.platform     = :ios, '6.0'
  s.requires_arc = true
  s.source_files = 'EXPMatchers+FBSnapshotTest.{h,m}'
  fb_def = 'FB_REFERENCE_IMAGE_DIR'
  fb_val = '"$(SOURCE_ROOT)/$(PROJECT_NAME)Tests/ReferenceImages"'
  s.prefix_header_contents = "#define #{fb_def} = #{fb_val}"
end
