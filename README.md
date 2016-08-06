# stepr
A stepper input library for iOS with cool animations.

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

	var c : NSLayoutConstraint?
    c = NSLayoutConstraint(item: stepr, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
    self.view.addConstraint(c!)
    c = NSLayoutConstraint(item: stepr, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
    self.view.addConstraint(c!)
    
    c = NSLayoutConstraint(item: stepr, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 250)
    self.view.addConstraint(c!)
    c = NSLayoutConstraint(item: stepr, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100)
    self.view.addConstraint(c!)

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


##### Custom Animations
You can change easing and timing of animations. You can check [anim](https://github.com/onurersel/anim) for all available easing types.

	stepr.easeDigitFadeIn = Stepr.Ease.CubicIn
    stepr.easeDigitFadeOut = Stepr.Ease.BackInOut
    stepr.easeDigitChangeEnter = Stepr.Ease.ExpoOut
    stepr.easeDigitChangeLeave = Stepr.Ease.QuartInOut
    stepr.easeDuration = 1
    stepr.easeShowDelay = 1


