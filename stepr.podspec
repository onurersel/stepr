#
#  Be sure to run `pod spec lint stepr.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "stepr"
  s.version      = "0.0.1"
  s.summary      = "A stepper input library with cool animations."

  s.description  = <<-DESC
# stepr
A stepper input library with cool animations.

![](https://github.com/onurersel/stepr/raw/master/screenshots/stepr-vertical-numbers.gif)

## Installation

#### CocoaPods
Easiest way to implement stepr to your project is via CocoaPods. Add this line to your Podfile:

  pod 'stepr'

#### Manual
Copy contents of stepr/stepr and stepr/images folders to your project. This library requires another library called [anim](https://github.com/onurersel/anim), so you have to implement it as well.


![](https://github.com/onurersel/stepr/raw/master/screenshots/stepr-horizontal-months.gif)


## How To Use

#### Initialization
You can initialize Stepr and add it to stage just like any other UIView

  let stepr = Stepr()
  self.view.addSubview(stepr)

#### Placement
Stepr both supports default frame placement and constraints.

#### Options

##### Custom Buttons
You can replace up and down buttons with your custom buttons. You just need to set how the buttons looks and don't need to worry about the interation.

  let up = UIButton()
  let down = UIButton()
  stepr.buttonAdd = up
  stepr.buttonRemove = down

##### Change Number
You can change current number (or index, if you're supplying a data array) programmatically.

  stepr.currentNumber = 152

##### Defining Limits
You can limit the current number.

  // current number stays between 0 and 100
  stepr.upperLimit = 100
  stepr.lowerLimit = 0

##### Fitting size of value inside boundaries
Fits the value inside frame width of stepr. It works quite similar to UILabel.adjustsFontSizeToFitWidth.

  stepr.adjustsFontSizeToFitWidth = true

##### Change Font
Changes font of value.

  stepr.font = UIFont.systemFontOfSize(64)

##### Change Text Color
Changes text color. 

  stepr.textColor = UIColor.redColor()

##### Custom Data
You can supply your own data array into stepr. It will display string representation of these values instead of numbers.

  // this will create a month stepper
  stepr.dataArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

##### Button Alignment
You can align buttons horizontally or vertically.

  stepr.buttonAlignment = Stepr.ButtonAlignment.Horizontal

                   DESC

  s.homepage     = "https://github.com/onurersel/stepr"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = { :type => "MIT", :file => "LICENSE" }
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "Onur Ersel" => "onurersel@gmail.com" }
  # Or just: s.author    = "Onur Ersel"
  # s.authors            = { "Onur Ersel" => "onurersel@gmail.com" }
  # s.social_media_url   = "http://twitter.com/Onur Ersel"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
  s.platform     = :ios, "8.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/onurersel/stepr.git", :tag => "v0.0.1" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "Classes", "stepr/stepr/*.swift"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  s.resources = "stepr/images/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "anim"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "anim", "~> 0.0.6"

end
