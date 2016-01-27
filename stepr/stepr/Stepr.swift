//
//  Stepr.swift
//  stepr
//
//  Created by Onur Ersel on 25/01/16.
//  Copyright © 2016 Onur Ersel. All rights reserved.
//

import Foundation
import UIKit


@objc public protocol SteprDelegate : NSObjectProtocol, UIScrollViewDelegate {
    optional func numberChanged (number : Int)
}



public class Stepr : UIView {
    
    
    
    /*****************************
     */
     //MARK: enums
     /*
     *****************************/
    
    public enum ButtonAlignment {
        case Horizontal, Vertical
    }
    
    
    public enum AnimationType {
        case ToDown, ToUp, FadeIn
    }

    
    /*****************************
     */
     //MARK: properties
     /*
     *****************************/
    
    
    public var delegate : SteprDelegate?
    public var selectionChangeCallback : ((number : Int)->Void)?
    
    private var number : SteprNumber?
    private var _buttonAlignment : ButtonAlignment = .Vertical
    private var _upperLimit : Int?
    private var _lowerLimit : Int?
    private var _buttonAdd : UIButton?
    private var _buttonRemove : UIButton?
    
    
    
    /*****************************
     */
     //MARK: getters/setters
     /*
     *****************************/
    
    // button which increases selection 
    // you can set your own custom UIButton for this
    public var buttonAdd : UIButton? {
        get {
            return _buttonAdd
        }
        set (v) {
            if let btn = _buttonAdd {
                btn.removeTarget(self, action: "addHandler", forControlEvents: .TouchUpInside)
                btn.removeFromSuperview()
            }
            
            _buttonAdd = v
            
            if let btn = _buttonAdd {
                self.addSubview(btn)
                btn.sizeToFit()
                btn.addTarget(self, action: "addHandler", forControlEvents: .TouchUpInside)
            }
            
            updateStatesWithLimits()
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    
    // button which decreases selection
    // you can set your own custom UIButton for this
    public var buttonRemove : UIButton? {
        get {
            return _buttonRemove
        }
        set (v) {
            if let btn = _buttonRemove {
                btn.removeTarget(self, action: "removeHandler", forControlEvents: .TouchUpInside)
                btn.removeFromSuperview()
            }
            
            _buttonRemove = v
            
            if let btn = _buttonRemove {
                self.addSubview(btn)
                btn.sizeToFit()
                btn.addTarget(self, action: "removeHandler", forControlEvents: .TouchUpInside)
            }
            
            updateStatesWithLimits()
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    
    // current selected number (or index, if stepr uses custom data)
    public var currentNumber : Int {
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
                if let ll = lowerLimit where ll > v {
                    print("Can not set current number to a value lower than lowerLimit. currentNumber:\(currentNumber)   setted number:\(v)   lowerLimit:\(ll)")
                    return
                } else if let ul = upperLimit where ul < v  {
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
    public var upperLimit : Int? {
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
    public var lowerLimit : Int? {
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
    public var dataArray : [AnyObject]? {
        get {
            return number!.dataArray
        }
        set (v) {
            number?.dataArray = v
            updateStatesWithLimits()
        }
    }
    
    
    // fits text inside stepr's frame width
    public var adjustsFontSizeToFitWidth : Bool {
        get {
            return number!.adjustsFontSizeToFitWidth
        }
        set (v) {
            number!.adjustsFontSizeToFitWidth = v
        }
    }
    
    
    // change font
    public var font : UIFont {
        get {
            return number!.font
        }
        set (v) {
            number!.font = v
        }
    }
    
    
    // change text color (unfortunalety, this is not animatable)
    public var textColor : UIColor {
        get {
            return number!.textColor
        }
        set (v) {
            number!.textColor = v
        }
    }
    
    
    // you can display add/remove buttons vertically and horizontally
    public var buttonAlignment : Stepr.ButtonAlignment {
        get {
            return _buttonAlignment
        }
        set (v) {
            _buttonAlignment = v
            
            setNeedsLayout()
            layoutIfNeeded()
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
    
    
    private func prepare () {
        
        //number
        number = SteprNumber()
        self.addSubview(number!)
        
        //button add
        let btnAdd = UIButton()
        btnAdd.setImage(UIImage(named:"arrow-up"), forState: .Normal)
        buttonAdd = btnAdd
        
        //button remove
        let btnRemove = UIButton()
        btnRemove.setImage(UIImage(named:"arrow-down"), forState: .Normal)
        buttonRemove = btnRemove
        
        //number change callback
        number!.numberChangeCallback = numberChangedHandler
    }
    
    
    /*****************************
     */
     //MARK: layout
     /*
     *****************************/
    
    override public func layoutSubviews() {
        number?.frame.size.width = self.frame.size.width
        number?.frame.size.height = self.frame.size.height
        
        switch _buttonAlignment {
        case .Vertical:
            buttonAdd?.frame.origin.x = self.frame.size.width/2.0 - buttonAdd!.frame.size.width/2.0
            buttonAdd?.frame.origin.y = 0
            buttonRemove?.frame.origin.x = self.frame.size.width/2.0 - buttonRemove!.frame.size.width/2.0
            buttonRemove?.frame.origin.y = self.frame.size.height - buttonRemove!.frame.size.height
            
        case .Horizontal:
            buttonRemove?.frame.origin.x = 0
            buttonRemove?.frame.origin.y = self.frame.size.height/2.0 - buttonAdd!.frame.size.height/2.0
            buttonAdd?.frame.origin.x = self.frame.size.width - buttonRemove!.frame.size.width
            buttonAdd?.frame.origin.y = self.frame.size.height/2.0 - buttonRemove!.frame.size.height/2.0
        }
        

        
        super.layoutSubviews()
    }
    
    private func updateStatesWithLimits() {
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
                if number?.currentNumber == ll  &&  buttonRemove!.enabled {
                    buttonRemove!.enabled = false
                } else if number?.currentNumber != ll  &&  !buttonRemove!.enabled {
                    buttonRemove!.enabled = true
                }
                
            }
            
            //upper limit
            if let ul = upper {
                
                //fit number in upper limit
                if cn > ul {
                    number?.changeNumber(ul)
                }
                
                //enable/disable add button
                if number?.currentNumber == ul  &&  buttonAdd!.enabled {
                    buttonAdd!.enabled = false
                } else if number?.currentNumber != ul  &&  !buttonAdd!.enabled {
                    buttonAdd!.enabled = true
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
    
    private func numberChangedHandler (number : Int) {
        
        delegate?.numberChanged?(number)
        
        selectionChangeCallback?(number: number)
        
    }
    
    
    
}

