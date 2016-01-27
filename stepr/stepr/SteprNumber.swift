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
    var numberChangeCallback : ((number : Int)->Void)?
    
    private var digitContainer : UIView?
    private var currentDigits = [SteprDigit]()
    private var digitPool = [SteprDigit]()
    private var _adjustsFontSizeToFitWidth : Bool = false
    private var _dataArray : [AnyObject]?
    private var _font : UIFont = UIFont.systemFontOfSize(64)
    private var _textColor : UIColor = UIColor(white: 0.81, alpha: 1)
    
    
    
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
    
    
    
    private func prepare () {
        
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
    func changeNumber (number : Int) {
        updateCurrentItem(number)
        numberChangeCallback?(number: number)
    }
    
    func updateCurrentItem (i : Int) {
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
    
    
    private func placeNumber (num : Int) {
        
        //don't place same numbers
        if currentNumber == num {
            return
        }
        
        //setting animation type
        var animationType : Stepr.AnimationType
        if let cn = currentNumber {
            if cn < num {
                animationType = Stepr.AnimationType.ToDown
            } else {
                animationType = Stepr.AnimationType.ToUp
            }
        } else {
            animationType = Stepr.AnimationType.FadeIn
        }
        
        
        let numStr = String(num)
        let count = max(numStr.characters.count, currentDigits.count)
        
        
        for var i = 0; i < count; ++i {
            
            if i < numStr.characters.count {
                let char = numStr[numStr.startIndex.advancedBy(i)]
                
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
                        currentDigits.removeAtIndex(i)
                        digit.hideAnimation(animationType) {
                            self.recycleDigit(digit)
                        }
                        
                        //add new digit
                        let d = requestDigit(String(char))
                        digitContainer!.addSubview(d)
                        currentDigits.insert(d, atIndex: i)
                        
                        d.showAnimation(animationType)
                        
                    }
                }
            } else {
                
                //remove excess digits
                let digit = currentDigits[i]
                currentDigits.removeAtIndex(i)
                
                digit.hideAnimation(animationType) {
                    self.recycleDigit(digit)
                }
                
            }
        }
        
        
        placeDigits(animate: true)
        currentNumber = num
    }
    
    private func placeData (index : Int) {
        
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
                animationType = Stepr.AnimationType.ToDown
            } else {
                animationType = Stepr.AnimationType.ToUp
            }
        } else {
            animationType = Stepr.AnimationType.FadeIn
        }
        
        //string to display
        let str = String(dataArray![index])
        
        //show item for the first time
        if currentDigits.count == 0 {
            let digit = requestDigit(str)
            digitContainer!.addSubview(digit)
            currentDigits.append(digit)
            digit.showAnimation(animationType)
        } else {
            
            //remove old item
            let digit = currentDigits[0]
            currentDigits.removeAtIndex(0)
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
    
    
    private func resetItems () {
        
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
    
    private func requestDigit (digitStr : String) -> SteprDigit {
        
        var digit : SteprDigit
        
        if digitPool.count > 0 {
            digit = digitPool[0]
            digitPool.removeAtIndex(0)
        } else {
            digit = SteprDigit(font: font, textColor: textColor)
        }
        
        resetDigitTransform(digit)
        digit.text = digitStr
        
        return digit
    }
    
    private func recycleDigit (digit : SteprDigit) {
        
        digit.removeFromSuperview()
        digitPool.append(digit)
        
    }
    
    
    /*****************************
     */
     //MARK: layout
     /*
     *****************************/
    
    private func placeDigits (animate doAnimate : Bool) {
        
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
            
            let size = str.sizeWithAttributes([NSFontAttributeName:font])
            
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
            
            anim(duration:SteprDigit.duration, easing: Ease.ExpoOut) {
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
    private func resetContainerTransform () {
        digitContainer?.transform = CGAffineTransformIdentity
    }
    private func applyContainerTransform () {
        if _adjustsFontSizeToFitWidth  &&  currentDigits.count > 0 {
            if let dc = digitContainer {
                
                let lastDigit = currentDigits.last!
                
                //update sizes
                dc.frame.size.width = lastDigit.frame.origin.x + lastDigit.frame.size.width
                dc.frame.size.height = lastDigit.frame.size.height
                
                //apply transform
                let ratio = self.frame.size.width / dc.frame.size.width
                if ratio < 1  &&  ratio > 0 {
                    dc.transform = CGAffineTransformMakeScale(ratio, ratio)
                }
            }
        }
    }
    
    
    // digit transform
    private func applyDigitTransform (digit : SteprDigit) {
        if _adjustsFontSizeToFitWidth {
            
            //apply transform
            let ratio = self.frame.size.width / digit.frame.size.width
            print("\(self.frame.size.width)  \(digit.frame.size.width)")
            if ratio < 1  &&  ratio > 0 {
                digit.transform = CGAffineTransformMakeScale(ratio, ratio)
            }
        }
    }
    private func resetDigitTransform (digit : SteprDigit) {
        digit.transform = CGAffineTransformIdentity
    }
    
    
    // layout override
    override func layoutSubviews() {
        super.layoutSubviews()
        
        placeDigits(animate: false)
    }
}
