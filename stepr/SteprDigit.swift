//
//  SteprDigit.swift
//  stepr
//
//  Created by Onur Ersel on 21/01/16.
//  Copyright © 2016 Onur Ersel. All rights reserved.
//

import UIKit
import anim

class SteprDigit : UIView {
    
    static let distance : CGFloat = 50
    static let duration : NSTimeInterval = 0.26
    static let showDelay : NSTimeInterval = 0.06
    
    var label : UILabel?
    
    var text : String {
        get {
            return (label?.text ?? "")
        }
        set (digitString){
            if label == nil {
                label = UILabel()
                label!.textColor = UIColor.blackColor()
                label!.font = UIFont.systemFontOfSize(64)
                self.addSubview(label!)
            }
            
            label!.text = digitString
            label!.sizeToFit()
            self.frame.size.width = label!.frame.size.width
            self.frame.size.height = label!.frame.size.height
        }
    }
    
    
    func showAnimation (oldNumber : Int?) {
        
        if let on = oldNumber {
            
            let newNumber = Int(self.text)
            if on == newNumber {
                //number didn't change, don't animate
            } else {
                if newNumber > on {
                    
                    //number is bigger, fade in from below
                    self.label!.frame.origin.y = -SteprDigit.distance
                    
                    anim(duration: SteprDigit.duration, delay: SteprDigit.showDelay, easing: Ease.BackOut) {
                        self.label!.frame.origin.y = 0
                    }
                    
                    
                } else {
                    
                    //number is smaller, fade in from above
                    self.label!.frame.origin.y = SteprDigit.distance
                    anim(duration: SteprDigit.duration, delay: SteprDigit.showDelay, easing: Ease.BackOut) {
                        self.label!.frame.origin.y = 0
                    }
                }
            }
            
        }
        
        
        //fade in
        self.alpha = 0
        
        anim(duration: SteprDigit.duration, delay: SteprDigit.showDelay, easing: Ease.QuintOut) {
            self.alpha = 1
        }
        
    }
    
    
    func hideAnimation (newNumber  : Int?) {
        
        if let nn = newNumber {
            
            let oldNumber = Int(self.text)
            if nn == oldNumber {
                //number didn't change, fade out
            } else {
                if nn > oldNumber {
                    
                    //number is bigger, fade out to above
                    self.label!.frame.origin.y = 0
                    
                    anim(duration: SteprDigit.duration, easing: Ease.QuintOut) {
                        self.label!.frame.origin.y = SteprDigit.distance
                    }
                    
                    
                } else {
                    
                    //number is smaller, fade out to below
                    self.label!.frame.origin.y = 0
                    anim(duration: SteprDigit.duration, easing: Ease.QuintOut) {
                        self.label!.frame.origin.y = -SteprDigit.distance
                    }
                }
            }
            
        }
        
        
        //fade out
        self.alpha = 1
        anim(duration: SteprDigit.duration, easing: Ease.QuintOut) {
            self.alpha = 0
        }
        
    }
    
    
}
