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
    static var font : UIFont = UIFont.systemFontOfSize(64)
    static var textColor : UIColor = UIColor(white: 0.81, alpha: 1)
    
    var label : UILabel?
    
    var text : String {
        get {
            return (label?.text ?? "")
        }
        set (digitString){
            if label == nil {
                label = UILabel()
                label!.textColor = SteprDigit.textColor
                label!.font = SteprDigit.font
                
                self.addSubview(label!)
            }
            
            label!.text = digitString
            fit()
        }
    }
    
    
    func fit () {
        label!.sizeToFit()
        self.frame.size.width = label!.frame.size.width
        self.frame.size.height = label!.frame.size.height
    }
    
    
    func updateFont (f : UIFont) {
        label!.font = f
        fit()
    }
    func updateTextColor (textColor : UIColor) {
        label!.textColor = textColor
    }
    
    
    func showAnimation (type : Stepr.AnimationType) {
        
        switch type {
            
        case .ToDown:
            
            //number is bigger, fade in from below
            self.label!.frame.origin.y = -SteprDigit.distance
            anim(duration: SteprDigit.duration, delay: SteprDigit.showDelay, easing: Ease.BackOut) {
                self.label!.frame.origin.y = 0
            }
            
            
        case .ToUp:
            
            //number is smaller, fade in from above
            self.label!.frame.origin.y = SteprDigit.distance
            anim(duration: SteprDigit.duration, delay: SteprDigit.showDelay, easing: Ease.BackOut) {
                self.label!.frame.origin.y = 0
            }
            
        default:
            break
        }
        
        
        
        //fade in
        self.alpha = 0
        anim(duration: SteprDigit.duration, delay: SteprDigit.showDelay, easing: Ease.QuintOut) {
            self.alpha = 1
        }
    }
    
    
    func hideAnimation (type : Stepr.AnimationType) {
        
        switch type {
            
        case .ToDown:
            
            //number is bigger, fade out to above
            self.label!.frame.origin.y = 0
            anim(duration: SteprDigit.duration, easing: Ease.QuintOut) {
                self.label!.frame.origin.y = SteprDigit.distance
            }
            
            
            
        case .ToUp:
            
            //number is smaller, fade out to below
            self.label!.frame.origin.y = 0
            anim(duration: SteprDigit.duration, easing: Ease.QuintOut) {
                self.label!.frame.origin.y = -SteprDigit.distance
            }
            
        default:
            break
        }
        
        
        //fade out
        self.alpha = 1
        anim(duration: SteprDigit.duration, easing: Ease.QuintOut) {
            self.alpha = 0
        }
    }
    
    
}
