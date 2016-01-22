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
    
    
    var digitContainer : UIView?
    var currentDigits = [SteprDigit]()
    
    var currentNumber : Int?
    var didPlacedBefore : Bool = false
    
    func prepare () {
        
        
        //digit container
        digitContainer = UIView()
        self.addSubview(digitContainer!)
        
        placeNumber(8)
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "test1", userInfo: nil, repeats: true)
        
    }
    
    
    @objc func test1 () {
        placeNumber(currentNumber!+1)
    }
    
    
    
    private func placeNumber (num : Int) {
        
        let numStr = String(num)
        
        let count = max(numStr.characters.count, currentDigits.count)
        
        for var i = 0; i < count; ++i {
            
            if i < numStr.characters.count {
                let char = numStr[numStr.startIndex.advancedBy(i)]
                
                //if dont have enough digits
                if currentDigits.count <= i {
                    let digit = requestDigit(char)
                    digitContainer!.addSubview(digit)
                    currentDigits.append(digit)
                    digit.showAnimation(nil)
                } else {
                    
                    //get matching digit
                    let digit = currentDigits[i]
                    
                    //request new digit if current digit and char doesn't match
                    if digit.text != String(char) {
                        
                        let oldNum = Int(digit.text)
                        
                        //remove old digit
                        currentDigits.removeAtIndex(i)
                        digit.hideAnimation(Int(String(char)))
                        
                        //add new digit
                        let d = requestDigit(char)
                        digitContainer!.addSubview(d)
                        currentDigits.insert(d, atIndex: i)
                        
                        d.showAnimation(oldNum)
                        
                    }
                }
            } else {
                
                //remove excess digits
                let digit = currentDigits[i]
                currentDigits.removeAtIndex(i)
                
                digit.hideAnimation(nil)
                
            }
        }
        
        placeDigits(currentDigits)
        
        
        currentNumber = num
    }
    
    private func requestDigit (digitChar : Character) -> SteprDigit {
        
        var digit : SteprDigit
        
        digit = SteprDigit()
        digit.text = String(digitChar)
        
        return digit
    }
    
    
    
    
    private func placeDigits (digits : [SteprDigit]) {
        
        //abort if there's no digits
        if digits.count == 0 {
            return
        }
        
        
        //align digits
        var x : CGFloat = 0.0
        for d in digits {
            
            d.frame.origin.x = x
            d.frame.origin.y = 0
            
            x = d.frame.origin.x + d.frame.size.width
            
        }
        
        
        //align container
        if didPlacedBefore {
            
            anim(duration:SteprDigit.duration*1.5, easing: Ease.ExpoOut) {
                self.digitContainer!.frame.origin.x = self.frame.size.width/2.0 - x/2.0
                self.digitContainer!.frame.origin.y = self.frame.size.height/2.0 - digits[0].frame.size.height/2.0
            }
            
        } else {
            self.digitContainer!.frame.origin.x = self.frame.size.width/2.0 - x/2.0
            self.digitContainer!.frame.origin.y = self.frame.size.height/2.0 - digits[0].frame.size.height/2.0
        }
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        placeDigits(currentDigits)
        didPlacedBefore = true
    }
}
