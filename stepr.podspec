Pod::Spec.new do |s|
  s.name = 'stepr'
  s.version = '0.0.4'
  s.license = 'MIT'
  s.summary = 'A stepper input library with cool animations.'
  s.homepage = 'https://github.com/onurersel/stepr'
  s.authors = { 'Onur Ersel' => 'onurersel@gmail.com' }
  s.source = { :git => 'https://github.com/onurersel/stepr.git', :tag => s.version }
  s.social_media_url = 'https://twitter.com/ethestel'
  s.screenshots = [ "https://github.com/onurersel/stepr/raw/master/screenshots/stepr-vertical-numbers.gif",
                    "https://github.com/onurersel/stepr/raw/master/screenshots/stepr-horizontal-months.gif" ]

  s.ios.deployment_target = '8.0'

  s.source_files = 'stepr/stepr/*.swift'
  s.resources = ['stepr/images/*.png']

  s.requires_arc = true
  s.dependency "anim", "~> 0.0.7"
end