//
//  SteprNumber.swift
//  stepr
//
//  Created by Onur Ersel on 21/01/16.
//  Copyright © 2016 Onur Ersel. All rights reserved.
//

import UIKit

class SteprNumber : UIView {
    
    
    var digitContainer : UIView?
    var currentDigits = [UILabel]()
    
    
    var currentNumber : Int?
    
    func prepare () {
        
        
        //digit container
        digitContainer = UIView()
        self.addSubview(digitContainer!)
        
        placeNumber(12)
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "test1", userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "test2", userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "test3", userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "test4", userInfo: nil, repeats: false)
    }
    
    
    @objc func test1 () {
        placeNumber(13)
    }
    @objc func test2 () {
        placeNumber(136)
    }
    @objc func test3 () {
        placeNumber(8136)
    }
    @objc func test4 () {
        placeNumber(813)
    }
    
    
    
    private func placeNumber (num : Int) {
        
        
        let numStr = String(num)
        print("===========================  old:\(currentNumber)  new:\(num)")
        
        currentNumber = num
        
        let count = max(numStr.characters.count, currentDigits.count)
        
        for var i = 0; i < count; ++i {
            
            print("char index \(i)-----------")
            
            if i < numStr.characters.count {
                let char = numStr[numStr.startIndex.advancedBy(i)]
                
                //if dont have enough digits
                if currentDigits.count <= i {
                    let digit = requestDigit(char)
                    digitContainer!.addSubview(digit)
                    currentDigits.append(digit)
                    
                    print("insert \(String(char))")
                } else {
                    
                    //get matching digit
                    let digit = currentDigits[i]
                    
                    //request new digit if current digit and char doesn't match
                    if digit.text != String(char) {
                        
                        print("remove \(digit.text) and insert \(String(char))")
                        
                        //remove old digit
                        digit.removeFromSuperview()
                        currentDigits.removeAtIndex(i)
                        
                        //add new digit
                        let d = requestDigit(char)
                        digitContainer!.addSubview(d)
                        currentDigits.insert(d, atIndex: i)
                        
                    } else {
                        print("no change")
                    }
                }
            } else {
                
                //remove excess digits
                let digit = currentDigits[i]
                digit.removeFromSuperview()
                currentDigits.removeAtIndex(i)
                
                print("remove \(digit.text)")
            }
        }
        
        
        print("currentdigits count \(currentDigits.count)")
        
        UIView.animateWithDuration(0.5) {
            self.placeDigits(self.currentDigits)
        }
        
    }
    
    private func requestDigit (digitChar : Character) -> UILabel {
        
        var digit : UILabel
        
        digit = UILabel()
        digit.textColor = UIColor.blackColor()
        digit.font = UIFont.systemFontOfSize(64)
        
        digit.text = String(digitChar)
        digit.sizeToFit()
        return digit
    }
    
    
    
    
    private func placeDigits (digits : [UILabel]) {
        
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
        digitContainer!.frame.origin.x = self.frame.size.width/2.0 - x/2.0
        digitContainer!.frame.origin.y = self.frame.size.height/2.0 - digits[0].frame.size.height/2.0
        
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        placeDigits(currentDigits)
        
    }
}
