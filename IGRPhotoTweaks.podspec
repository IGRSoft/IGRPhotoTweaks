Pod::Spec.new do |spec|
  spec.name             = 'IGRPhotoTweaks'
  spec.version          = '1.0.0'
  spec.license          = 'MIT' 
  spec.homepage         = 'https://github.com/IGRSoft/IGRPhotoTweaks'
  spec.authors          = {'Vitalii Parovishnyk' => 'korich.vi.p@gmail.com'}
  spec.summary          = 'Drag, Rotate, Scale and Crop.'
  spec.source           = {:git => 'https://github.com/IGRSoft/IGRPhotoTweaks.git', :tag => '1.0.0'}
  spec.source_files     = 'IGRPhotoTweaks/*.swift'
  spec.framework        = 'Foundation', 'CoreGraphics', 'UIKit', 'Photos'
  spec.requires_arc     = true
  spec.platform         = :ios, '9.0'
  
  spec.subspec 'CropView' do |ss|
    ss.source_files = 'IGRPhotoTweaks/CropView/*.swift'
  end
  
  spec.subspec 'CustomViews' do |ss|
    ss.source_files = 'IGRPhotoTweaks/CustomViews/*.swift'
  end
  
end
