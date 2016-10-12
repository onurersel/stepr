//
//  SteprNumber.swift
//  stepr
//
//  Created by Onur Ersel on 21/01/16.
//  Copyright © 2016 Onur Ersel. All rights reserved.
//

import UIKit
import anim

class SteprNumber : UIView {
    
    
    /*****************************
     */
     //MARK: properties
     /*
     *****************************/
    
    var currentNumber : Int?
    var numberChangeCallback : ((_ number : Int)->Void)?
    
    fileprivate var digitContainer : UIView?
    fileprivate var currentDigits = [SteprDigit]()
    fileprivate var digitPool = [SteprDigit]()
    fileprivate var _adjustsFontSizeToFitWidth : Bool = false
    fileprivate var _dataArray : [AnyObject]?
    fileprivate var _font : UIFont = UIFont.systemFont(ofSize: 64)
    fileprivate var _textColor : UIColor = UIColor(white: 0.81, alpha: 1)
    
    fileprivate var _easeDigitFadeIn : Ease = Ease.quintOut
    fileprivate var _easeDigitFadeOut : Ease = Ease.quintOut
    fileprivate var _easeDigitChangeEnter : Ease = Ease.backOut
    fileprivate var _easeDigitChangeLeave : Ease = Ease.quintOut
    fileprivate var _easeHorizontalAlign : Ease = Ease.expoOut
    
    fileprivate var _easeDuration : TimeInterval = 0.26
    fileprivate var _easeShowDelay : TimeInterval = 0.06
    
    
    
    /*****************************
     */
     //MARK: getter / setter
     /*
     *****************************/
    
    
    var adjustsFontSizeToFitWidth : Bool {
        get {
            return _adjustsFontSizeToFitWidth
        }
        set (value) {
            _adjustsFontSizeToFitWidth = value
            
            resetContainerTransform()
            applyContainerTransform()
        }
    }
    
    var font : UIFont {
        get {
            return _font
        }
        set (f) {
            
            _font = f
            
            for digit in currentDigits {
                digit.font = f
            }
            
            placeDigits(animate: false)
            resetContainerTransform()
            applyContainerTransform()
        }
    }
    
    var textColor : UIColor {
        get {
            return _textColor
        }
        set (c) {
            
            _textColor = c
            
            for digit in currentDigits {
                digit.textColor = c
            }
        }
    }
    
    var dataArray : [AnyObject]? {
        get {
            return _dataArray
        }
        set (v) {
            _dataArray = v
            resetItems()
            updateCurrentItem(0)
        }
    }
    
    var easeDigitFadeIn : Ease {
        get {
            return _easeDigitFadeIn
        }
        set (v) {
            
            _easeDigitFadeIn = v
            
            for digit in currentDigits {
                digit.easeDigitFadeIn = v
            }
        }
    }
    
    var easeDigitFadeOut : Ease {
        get {
            return _easeDigitFadeOut
        }
        set (v) {
            
            _easeDigitFadeOut = v
            
            for digit in currentDigits {
                digit.easeDigitFadeOut = v
            }
        }
    }
    
    var easeDigitChangeEnter : Ease {
        get {
            return _easeDigitChangeEnter
        }
        set (v) {
            
            _easeDigitChangeEnter = v
            
            for digit in currentDigits {
                digit.easeDigitChangeEnter = v
            }
        }
    }
    
    var easeDigitChangeLeave : Ease {
        get {
            return _easeDigitChangeLeave
        }
        set (v) {
            
            _easeDigitChangeLeave = v
            
            for digit in currentDigits {
                digit.easeDigitChangeLeave = v
            }
        }
    }
    
    var easeHorizontalAlign : Ease {
        get {
            return _easeHorizontalAlign
        }
        set (v) {
            
            _easeHorizontalAlign = v
            
            for digit in currentDigits {
                digit.easeHorizontalAlign = v
            }
        }
    }
    
    var easeDuration : TimeInterval {
        get {
            return _easeDuration
        }
        set (v) {
            
            _easeDuration = v
            
            for digit in currentDigits {
                digit.easeDuration = v
            }
        }
    }
    
    var easeShowDelay : TimeInterval {
        get {
            return _easeShowDelay
        }
        set (v) {
            
            _easeShowDelay = v
            
            for digit in currentDigits {
                digit.easeShowDelay = v
            }
        }
    }
    
    
    /*****************************
     */
     //MARK: init / prepare
     /*
     *****************************/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    
    
    fileprivate func prepare () {
        
        //digit container
        digitContainer = UIView()
        self.addSubview(digitContainer!)
        
        updateCurrentItem(0)
    }
    
    
    
    /*****************************
     */
     //MARK: controls
     /*
     *****************************/
    
    
    func increase () {
        if let cn = currentNumber {
            changeNumber(cn+1)
        }
    }
    func decrease () {
        if let cn = currentNumber {
            changeNumber(cn-1)
        }
    }
    func changeNumber (_ number : Int) {
        updateCurrentItem(number)
        numberChangeCallback?(number)
    }
    
    func updateCurrentItem (_ i : Int) {
        if dataArray == nil {
            placeNumber(i)
        } else {
            placeData(i)
        }
    }
    
    
    /*****************************
     */
     //MARK: display items
     /*
     *****************************/
    
    
    fileprivate func placeNumber (_ num : Int) {
        
        //don't place same numbers
        if currentNumber == num {
            return
        }
        
        //setting animation type
        var animationType : Stepr.AnimationType
        if let cn = currentNumber {
            if cn < num {
                animationType = Stepr.AnimationType.toDown
            } else {
                animationType = Stepr.AnimationType.toUp
            }
        } else {
            animationType = Stepr.AnimationType.fadeIn
        }
        
        
        let numStr = String(num)
        let count = max(numStr.characters.count, currentDigits.count)
        
        
        for i in 0 ..< count {
            
            if i < numStr.characters.count {
                let char = numStr[numStr.characters.index(numStr.startIndex, offsetBy: i)]
                
                //if dont have enough digits
                if currentDigits.count <= i {
                    let digit = requestDigit(String(char))
                    digitContainer!.addSubview(digit)
                    currentDigits.append(digit)
                    digit.showAnimation(animationType)
                } else {
                    
                    //get matching digit
                    let digit = currentDigits[i]
                    
                    //request new digit if current digit and char doesn't match
                    if digit.text != String(char) {
                        
                        //remove old digit
                        currentDigits.remove(at: i)
                        digit.hideAnimation(animationType) {
                            self.recycleDigit(digit)
                        }
                        
                        //add new digit
                        let d = requestDigit(String(char))
                        digitContainer!.addSubview(d)
                        currentDigits.insert(d, at: i)
                        
                        d.showAnimation(animationType)
                        
                    }
                }
            } else {
                
                //remove excess digits
                let digit = currentDigits[i]
                currentDigits.remove(at: i)
                
                digit.hideAnimation(animationType) {
                    self.recycleDigit(digit)
                }
                
            }
        }
        
        
        placeDigits(animate: true)
        currentNumber = num
    }
    
    fileprivate func placeData (_ index : Int) {
        
        //don't place same indices
        if currentNumber == index {
            return
        }
        
        //there should be data
        if dataArray == nil {
            return
        }
        
        //index can't be bigger than data or smaller than 0
        if index >= dataArray!.count  ||  index < 0 {
            return
        }
        
        //setting animation type
        var animationType : Stepr.AnimationType
        if let cn = currentNumber {
            if cn < index {
                animationType = Stepr.AnimationType.toDown
            } else {
                animationType = Stepr.AnimationType.toUp
            }
        } else {
            animationType = Stepr.AnimationType.fadeIn
        }
        
        //string to display
        let str = String(describing: dataArray![index])
        
        //show item for the first time
        if currentDigits.count == 0 {
            let digit = requestDigit(str)
            digitContainer!.addSubview(digit)
            currentDigits.append(digit)
            digit.showAnimation(animationType)
        } else {
            
            //remove old item
            let digit = currentDigits[0]
            currentDigits.remove(at: 0)
            digit.hideAnimation(animationType) {
                self.recycleDigit(digit)
            }
            
            //add new item
            let d = requestDigit(str)
            digitContainer!.addSubview(d)
            currentDigits.append(d)
            
            d.showAnimation(animationType)
        }
        
        
        placeDigits(animate: true)
        currentNumber = index
    }
    
    
    fileprivate func resetItems () {
        
        for d in currentDigits {
            d.removeFromSuperview()
        }
        
        currentDigits.removeAll()
        digitPool.removeAll()
        
        currentNumber = nil
    }
    
    
    
    
    /*****************************
     */
     //MARK: digit factory
     /*
     *****************************/
    
    fileprivate func requestDigit (_ digitStr : String) -> SteprDigit {
        
        var digit : SteprDigit
        
        if digitPool.count > 0 {
            digit = digitPool[0]
            digitPool.remove(at: 0)
        } else {
            digit = SteprDigit(font: font, textColor: textColor, easeDigitFadeIn: easeDigitFadeIn, easeDigitFadeOut: easeDigitFadeOut, easeDigitChangeEnter: easeDigitChangeEnter, easeDigitChangeLeave: easeDigitChangeLeave, easeHorizontalAlign: easeHorizontalAlign, easeDuration: easeDuration, easeShowDelay: easeShowDelay)
        }
        
        resetDigitTransform(digit)
        digit.text = digitStr
        
        return digit
    }
    
    fileprivate func recycleDigit (_ digit : SteprDigit) {
        
        digit.removeFromSuperview()
        digitPool.append(digit)
        
    }
    
    
    /*****************************
     */
     //MARK: layout
     /*
     *****************************/
    
    fileprivate func placeDigits (animate doAnimate : Bool) {
        
        //if data is available, place everything to middle
        if dataArray != nil {
            
            resetContainerTransform()
            
            for d in currentDigits {
                resetDigitTransform(d)
                d.frame.origin.x = -d.frame.size.width/2.0
                applyDigitTransform(d)
            }
            
            let firstDigit = currentDigits.first!
            let str = NSString(string: firstDigit.text)
            
            let size = str.size(attributes: [NSFontAttributeName:font])
            
            self.digitContainer!.frame.origin.x = self.frame.size.width/2.0
            self.digitContainer!.frame.origin.y = self.frame.size.height/2.0 - size.height/2.0
            
            return
        }
        
        
        //abort if there's no digits
        if currentDigits.count == 0 {
            return
        }
        
        //reset transform on container
        resetContainerTransform()
        
        //align digits
        var x : CGFloat = 0.0
        for d in currentDigits {
            
            d.frame.origin.x = x
            d.frame.origin.y = 0
            
            x = d.frame.origin.x + d.frame.size.width
            
        }
        
        
        //align container
        if currentNumber != nil  &&  doAnimate {
            
            anim(duration:easeDuration, easing: easeHorizontalAlign) {
                self.digitContainer!.frame.origin.x = self.frame.size.width/2.0 - x/2.0
                self.digitContainer!.frame.origin.y = self.frame.size.height/2.0 - self.currentDigits[0].frame.size.height/2.0
            }
            
        } else {
            self.digitContainer!.frame.origin.x = self.frame.size.width/2.0 - x/2.0
            self.digitContainer!.frame.origin.y = self.frame.size.height/2.0 - currentDigits[0].frame.size.height/2.0
        }
        
        //resize container for adjustsFontSizeToFitWidth
        applyContainerTransform()
    }
    
    
    
    // container transform
    fileprivate func resetContainerTransform () {
        digitContainer?.transform = CGAffineTransform.identity
    }
    fileprivate func applyContainerTransform () {
        if _adjustsFontSizeToFitWidth  &&  currentDigits.count > 0 {
            if let dc = digitContainer {
                
                let lastDigit = currentDigits.last!
                
                //update sizes
                dc.frame.size.width = lastDigit.frame.origin.x + lastDigit.frame.size.width
                dc.frame.size.height = lastDigit.frame.size.height
                
                //apply transform
                let ratio = self.frame.size.width / dc.frame.size.width
                if ratio < 1  &&  ratio > 0 {
                    dc.transform = CGAffineTransform(scaleX: ratio, y: ratio)
                }
            }
        }
    }
    
    
    // digit transform
    fileprivate func applyDigitTransform (_ digit : SteprDigit) {
        if _adjustsFontSizeToFitWidth {
            
            //apply transform
            let ratio = self.frame.size.width / digit.frame.size.width
            print("\(self.frame.size.width)  \(digit.frame.size.width)")
            if ratio < 1  &&  ratio > 0 {
                digit.transform = CGAffineTransform(scaleX: ratio, y: ratio)
            }
        }
    }
    fileprivate func resetDigitTransform (_ digit : SteprDigit) {
        digit.transform = CGAffineTransform.identity
    }
    
    
    // layout override
    override func layoutSubviews() {
        super.layoutSubviews()
        
        placeDigits(animate: false)
    }
}
