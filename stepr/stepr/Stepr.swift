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
    
    
    public enum ButtonAlignment {
        case Horizontal, Vertical
    }
    
    
    public enum AnimationType {
        case ToDown, ToUp, FadeIn
    }

    
    public var delegate : SteprDelegate?
    public var numberChangeCallback : ((number : Int)->Void)?
    
    private var number : SteprNumber?
    private var buttonAdd : UIButton?
    private var buttonRemove : UIButton?
    private var buttonAlignment : ButtonAlignment = .Vertical
    private var _upperLimit : Int?
    private var _lowerLimit : Int?
    
    
    public var currentNumber : Int {
        get {
            if let cn = number!.currentNumber {
                return cn
            } else {
                return 0
            }
        }
        set (v) {
            if let ll = lowerLimit {
                assert(ll <= v, "Your setted current number should be bigger than lower limit")
            } else if let ul = upperLimit {
                assert(ul >= v, "Your setted current number should be smaller than upper limit")
            } else {
                number?.updateCurrentItem(v)
            }
        }
    }
    
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
    
    public var dataArray : [AnyObject]? {
        get {
            return number!.dataArray
        }
        set (v) {
            if let d = v {
                lowerLimit = 0
                upperLimit = d.count-1
                number?.dataArray = d
            } else {
                lowerLimit = nil
                upperLimit = nil
                number?.dataArray = nil
            }
            
            updateStatesWithLimits()
        }
    }
    
    public var adjustsFontSizeToFitWidth : Bool {
        get {
            return number!.adjustsFontSizeToFitWidth
        }
        set (v) {
            number!.adjustsFontSizeToFitWidth = v
        }
    }
    
    public var font : UIFont {
        get {
            return number!.font
        }
        set (v) {
            number!.font = v
        }
    }
    
    public var textColor : UIColor {
        get {
            return number!.textColor
        }
        set (v) {
            number!.textColor = v
        }
    }
    
    
    
    
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
        buttonAlignment = alignment
        dataArray = data
    }
    
    
    private func prepare () {
        
        //number
        number = SteprNumber()
        self.addSubview(number!)
        
        //button add
        buttonAdd = UIButton()
        self.addSubview(buttonAdd!)
        buttonAdd?.setImage(UIImage(named: "arrow-up"), forState: .Normal)
        buttonAdd?.sizeToFit()
        buttonAdd?.addTarget(self, action: "addHandler", forControlEvents: .TouchUpInside)
        
        //button remove
        buttonRemove = UIButton()
        self.addSubview(buttonRemove!)
        buttonRemove?.setImage(UIImage(named: "arrow-down"), forState: .Normal)
        buttonRemove?.sizeToFit()
        buttonRemove?.addTarget(self, action: "removeHandler", forControlEvents: .TouchUpInside)
        
        //number change callback
        number!.numberChangeCallback = numberChangedHandler
    }
    
    
    
    override public func layoutSubviews() {
        number?.frame.size.width = self.frame.size.width
        number?.frame.size.height = self.frame.size.height
        
        switch buttonAlignment {
        case .Vertical:
            buttonAdd?.frame.origin.x = self.frame.size.width/2.0 - buttonAdd!.frame.size.width/2.0
            buttonAdd?.frame.origin.y = 0
            buttonRemove?.frame.origin.x = self.frame.size.width/2.0 - buttonRemove!.frame.size.width/2.0
            buttonRemove?.frame.origin.y = self.frame.size.height - buttonRemove!.frame.size.height
            
        case .Horizontal:
            buttonAdd?.frame.origin.x = 0
            buttonAdd?.frame.origin.y = self.frame.size.height/2.0 - buttonAdd!.frame.size.height/2.0
            buttonRemove?.frame.origin.x = self.frame.size.width - buttonRemove!.frame.size.width
            buttonRemove?.frame.origin.y = self.frame.size.height/2.0 - buttonRemove!.frame.size.height/2.0
        }
        

        
        super.layoutSubviews()
    }
    
    private func updateStatesWithLimits() {
        
        if let cn = number?.currentNumber {
            
            //lower limit
            if let ll = lowerLimit {
                
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
            
            if let ul = upperLimit {
                
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
        
        numberChangeCallback?(number: number)
        
    }
    
    
    
}

