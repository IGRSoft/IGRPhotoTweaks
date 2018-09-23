Pod::Spec.new do |spec|
  spec.name                = 'IGRPhotoTweaks'
  spec.version             = '1.0.8'
  spec.platform            = :ios, '9.0'
  
  spec.license             = { :type => "MIT", :file => "LICENSE" }
  spec.homepage            = 'https://github.com/IGRSoft/IGRPhotoTweaks'
  spec.authors             = {'Vitalii Parovishnyk' => 'korich.vi.p@gmail.com'}
  spec.summary             = 'Drag, Rotate, Scale and Crop.'
  
  spec.source              = {:git => 'https://github.com/IGRSoft/IGRPhotoTweaks.git', :tag => spec.version}
  
  spec.source_files        = 'IGRPhotoTweaks/**/*.{h,swift}'
  
  spec.framework           = 'Foundation', 'CoreGraphics', 'UIKit', 'Photos'
  spec.requires_arc        = true

  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
end
