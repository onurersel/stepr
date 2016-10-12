//
//  Stepr.swift
//  stepr
//
//  Created by Onur Ersel on 25/01/16.
//  Copyright © 2016 Onur Ersel. All rights reserved.
//

import Foundation
import UIKit
import anim
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}



@objc public protocol SteprDelegate : NSObjectProtocol, UIScrollViewDelegate {
    @objc optional func numberChanged (_ number : Int)
}



open class Stepr : UIView {
    
    
    public typealias Ease = anim.Ease
    
    
    /*****************************
     */
     //MARK: enums
     /*
     *****************************/
    
    public enum ButtonAlignment {
        case horizontal, vertical
    }
    
    
    public enum AnimationType {
        case toDown, toUp, fadeIn
    }

    
    /*****************************
     */
     //MARK: properties
     /*
     *****************************/
    
    open var delegate : SteprDelegate?
    open var selectionChangeCallback : ((_ number : Int)->Void)?
    
    fileprivate var number : SteprNumber?
    fileprivate var _buttonAlignment : ButtonAlignment = .vertical
    fileprivate var _upperLimit : Int?
    fileprivate var _lowerLimit : Int?
    fileprivate var _buttonAdd : UIButton?
    fileprivate var _buttonRemove : UIButton?
    
    
    /*****************************
     */
     //MARK: getters/setters
     /*
     *****************************/
    
    // button which increases selection 
    // you can set your own custom UIButton for this
    open var buttonAdd : UIButton? {
        get {
            return _buttonAdd
        }
        set (v) {
            if let btn = _buttonAdd {
                btn.removeTarget(self, action: #selector(Stepr.addHandler), for: .touchUpInside)
                btn.removeFromSuperview()
            }
            
            _buttonAdd = v
            
            if let btn = _buttonAdd {
                self.addSubview(btn)
                btn.sizeToFit()
                btn.addTarget(self, action: #selector(Stepr.addHandler), for: .touchUpInside)
            }
            
            updateStatesWithLimits()
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    
    // button which decreases selection
    // you can set your own custom UIButton for this
    open var buttonRemove : UIButton? {
        get {
            return _buttonRemove
        }
        set (v) {
            if let btn = _buttonRemove {
                btn.removeTarget(self, action: #selector(Stepr.removeHandler), for: .touchUpInside)
                btn.removeFromSuperview()
            }
            
            _buttonRemove = v
            
            if let btn = _buttonRemove {
                self.addSubview(btn)
                btn.sizeToFit()
                btn.addTarget(self, action: #selector(Stepr.removeHandler), for: .touchUpInside)
            }
            
            updateStatesWithLimits()
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    
    // current selected number (or index, if stepr uses custom data)
    open var currentNumber : Int {
        get {
            if let cn = number!.currentNumber {
                return cn
            } else {
                return 0
            }
        }
        set (v) {
            
            if let arr = dataArray {
                if v < 0 {
                    print("Can not set current number to a value lower than 0 while data array is defined. currentNumber:\(currentNumber)   setted number:\(v)")
                    return
                } else if v > arr.count-1 {
                    print("Can not set current number to a value greater than dataArray.count-1 while data array is defined. currentNumber:\(currentNumber)   setted number:\(v)   dataArray.count:\(dataArray!.count)")
                    return
                }
            } else {
                if let ll = lowerLimit , ll > v {
                    print("Can not set current number to a value lower than lowerLimit. currentNumber:\(currentNumber)   setted number:\(v)   lowerLimit:\(ll)")
                    return
                } else if let ul = upperLimit , ul < v  {
                    print("Can not set current number to a value greater than upperLimit. currentNumber:\(currentNumber)   setted number:\(v)   upperLimit:\(ul)")
                    return
                }
            }
            
            number?.updateCurrentItem(v)
            updateStatesWithLimits()
        }
    }
    
    // you can set an upper and lower number (or index) limit
    // current number will be adjusted to fit in limits after you define limits
    // to remove limits, just nullify limit values
    open var upperLimit : Int? {
        get {
            return _upperLimit
        }
        set (v) {
            if _lowerLimit == nil  ||  _lowerLimit! <= v {
                _upperLimit = v
                updateStatesWithLimits()
            }
        }
    }
    open var lowerLimit : Int? {
        get {
            return _lowerLimit
        }
        set (v) {
            if _upperLimit == nil  ||  _upperLimit! >= v {
                _lowerLimit = v
                updateStatesWithLimits()
            }
        }
    }
    
    
    // you can assign a custom data array to stepr, and it displays its' value's String representation
    // bounds of data array also acts as upper and lower limits
    open var dataArray : [AnyObject]? {
        get {
            return number!.dataArray
        }
        set (v) {
            number?.dataArray = v
            updateStatesWithLimits()
        }
    }
    
    
    // fits text inside stepr's frame width
    open var adjustsFontSizeToFitWidth : Bool {
        get {
            return number!.adjustsFontSizeToFitWidth
        }
        set (v) {
            number!.adjustsFontSizeToFitWidth = v
        }
    }
    
    
    // change font
    open var font : UIFont {
        get {
            return number!.font
        }
        set (v) {
            number!.font = v
        }
    }
    
    
    // change text color (unfortunalety, this is not animatable)
    open var textColor : UIColor {
        get {
            return number!.textColor
        }
        set (v) {
            number!.textColor = v
        }
    }
    
    
    // you can display add/remove buttons vertically and horizontally
    open var buttonAlignment : Stepr.ButtonAlignment {
        get {
            return _buttonAlignment
        }
        set (v) {
            _buttonAlignment = v
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    

    // ease type of digit fade in animation when it's appearing on screen
    open var easeDigitFadeIn : Stepr.Ease {
        get {
            return number!.easeDigitFadeIn
        }
        set (v) {
            number!.easeDigitFadeIn = v
        }
    }
    
    
    // ease type of digit fade out animation when it's leaving screen
    open var easeDigitFadeOut : Stepr.Ease {
        get {
            return number!.easeDigitFadeOut
        }
        set (v) {
            number!.easeDigitFadeOut = v
        }
    }
    
    // ease type of digit movement animation when it's appearing on screen
    open var easeDigitChangeEnter : Stepr.Ease {
        get {
            return number!.easeDigitChangeEnter
        }
        set (v) {
            number!.easeDigitChangeEnter = v
        }
    }
    
    
    // ease type of digit movement animation when it's leaving on screen
    open var easeDigitChangeLeave : Stepr.Ease {
        get {
            return number!.easeDigitChangeLeave
        }
        set (v) {
            number!.easeDigitChangeLeave = v
        }
    }
    
    
    // ease type of digits' horizontal alignment.
    open var easeHorizontalAlign : Stepr.Ease {
        get {
            return number!.easeHorizontalAlign
        }
        set (v) {
            number!.easeHorizontalAlign = v
        }
    }
    
    // ease duration
    open var easeDuration : TimeInterval {
        get {
            return number!.easeDuration
        }
        set (v) {
            number!.easeDuration = v
        }
    }
    
    // delay value between a digit leaves screen and a new one enters.
    open var easeShowDelay : TimeInterval {
        get {
            return number!.easeShowDelay
        }
        set (v) {
            number!.easeShowDelay = v
        }
    }
    
    
    
    /*****************************
     */
     //MARK: init & prepare
     /*
     *****************************/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    
    convenience init (alignment : ButtonAlignment) {
        self.init(alignment: alignment, data : nil)
    }
    convenience init (alignment : ButtonAlignment, data : [AnyObject]?) {
        self.init(frame: CGRect.zero)
        _buttonAlignment = alignment
        dataArray = data
    }
    
    
    fileprivate func prepare () {
        
        //number
        number = SteprNumber()
        self.addSubview(number!)
        
        //button add
        let btnAdd = UIButton()
        btnAdd.setImage(steprImageNamed("arrow-up"), for: UIControlState())
        buttonAdd = btnAdd
        
        //button remove
        let btnRemove = UIButton()
        btnRemove.setImage(steprImageNamed("arrow-down"), for: UIControlState())
        buttonRemove = btnRemove
        
        //number change callback
        number!.numberChangeCallback = numberChangedHandler
    }
    
    
    fileprivate func steprImageNamed (_ name : String) -> UIImage {
        let bundle = Bundle(for: self.classForCoder)
        let resourcePath = bundle.path(forResource: name, ofType: ".png")
        
        return UIImage(contentsOfFile: resourcePath!)!
    }
    
    
    /*****************************
     */
     //MARK: layout
     /*
     *****************************/
    
    override open func layoutSubviews() {
        number?.frame.size.width = self.frame.size.width
        number?.frame.size.height = self.frame.size.height
        
        switch _buttonAlignment {
        case .vertical:
            buttonAdd?.frame.origin.x = self.frame.size.width/2.0 - buttonAdd!.frame.size.width/2.0
            buttonAdd?.frame.origin.y = 0
            buttonRemove?.frame.origin.x = self.frame.size.width/2.0 - buttonRemove!.frame.size.width/2.0
            buttonRemove?.frame.origin.y = self.frame.size.height - buttonRemove!.frame.size.height
            
        case .horizontal:
            buttonRemove?.frame.origin.x = 0
            buttonRemove?.frame.origin.y = self.frame.size.height/2.0 - buttonAdd!.frame.size.height/2.0
            buttonAdd?.frame.origin.x = self.frame.size.width - buttonRemove!.frame.size.width
            buttonAdd?.frame.origin.y = self.frame.size.height/2.0 - buttonRemove!.frame.size.height/2.0
        }
        

        
        super.layoutSubviews()
    }
    
    fileprivate func updateStatesWithLimits() {
        if let cn = number?.currentNumber {
            
            let lower : Int? = (dataArray != nil ? 0 : lowerLimit)
            let upper : Int? = (dataArray != nil ? dataArray!.count-1 : upperLimit)
            
            //lower limit
            if let ll = lower {
                
                //fit number in lower limit
                if cn < ll {
                    number?.changeNumber(ll)
                }
                
                //enable/disable remove button
                if number?.currentNumber == ll  &&  buttonRemove!.isEnabled {
                    buttonRemove!.isEnabled = false
                } else if number?.currentNumber != ll  &&  !buttonRemove!.isEnabled {
                    buttonRemove!.isEnabled = true
                }
                
            }
            
            //upper limit
            if let ul = upper {
                
                //fit number in upper limit
                if cn > ul {
                    number?.changeNumber(ul)
                }
                
                //enable/disable add button
                if number?.currentNumber == ul  &&  buttonAdd!.isEnabled {
                    buttonAdd!.isEnabled = false
                } else if number?.currentNumber != ul  &&  !buttonAdd!.isEnabled {
                    buttonAdd!.isEnabled = true
                }
                
            }
            
        }
    }
    
    /*****************************
    */
    //MARK: handlers
    /*
    *****************************/
    
    @objc func addHandler () {
        number?.increase()
        updateStatesWithLimits()
    }
    
    @objc func removeHandler () {
        number?.decrease()
        updateStatesWithLimits()
    }
    
    fileprivate func numberChangedHandler (_ number : Int) {
        
        delegate?.numberChanged?(number)
        
        selectionChangeCallback?(number)
        
    }
    
    
    
}

