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
    
    /*****************************
     */
     //MARK: constants
     /*
     *****************************/
    
    static let distance : CGFloat = 50
    
    /*****************************
     */
     //MARK: properties
     /*
     *****************************/
    
    private var label : UILabel?
    private var _font : UIFont?
    private var _textColor : UIColor?
    
    internal var easeDigitFadeIn : Stepr.Ease?
    internal var easeDigitFadeOut : Stepr.Ease?
    internal var easeDigitChangeEnter : Stepr.Ease?
    internal var easeDigitChangeLeave : Stepr.Ease?
    internal var easeHorizontalAlign : Stepr.Ease?
    
    internal var easeDuration : NSTimeInterval?
    internal var easeShowDelay : NSTimeInterval?
    
    
    
    /*****************************
     */
     //MARK: getter/setter
     /*
     *****************************/
    
    var text : String {
        get {
            return (label?.text ?? "")
        }
        set (digitString){
            if label == nil {
                label = UILabel()
                label!.textColor = textColor
                label!.font = font
                
                self.addSubview(label!)
            }
            
            label!.text = digitString
            fit()
        }
    }
    
    var font : UIFont? {
        get {
            return _font
        }
        set (v) {
            _font = v
            label?.font = _font
            fit()
        }
    }
    
    var textColor : UIColor? {
        get {
            return _textColor
        }
        set (v) {
            _textColor = v
            label?.textColor = _textColor
        }
    }
    
    
    
    /*****************************
     */
     //MARK: init / prepare
     /*
     *****************************/
    
    
    convenience init (font : UIFont, textColor : UIColor, easeDigitFadeIn : Stepr.Ease, easeDigitFadeOut : Stepr.Ease, easeDigitChangeEnter : Stepr.Ease, easeDigitChangeLeave : Stepr.Ease, easeHorizontalAlign : Stepr.Ease, easeDuration : NSTimeInterval, easeShowDelay : NSTimeInterval) {
        self.init()
        self.font = font
        self.textColor = textColor
        
        self.easeDigitFadeIn = easeDigitFadeIn
        self.easeDigitFadeOut = easeDigitFadeOut
        self.easeDigitChangeEnter = easeDigitChangeEnter
        self.easeDigitChangeLeave = easeDigitChangeLeave
        self.easeHorizontalAlign = easeHorizontalAlign
        
        self.easeDuration = easeDuration
        self.easeShowDelay = easeShowDelay
    }
    
    
    
    
    
    /*****************************
     */
     //MARK: layout
     /*
     *****************************/
     
    func fit () {
        if let l = label {
            l.sizeToFit()
            self.frame.size.width = l.frame.size.width
            self.frame.size.height = l.frame.size.height
        }
    }
    
    
    
    /*****************************
     */
     //MARK: animations
     /*
     *****************************/
    
    func showAnimation (type : Stepr.AnimationType) {
        
        switch type {
            
        case .ToDown:
            
            //number is bigger, fade in from below
            self.label!.frame.origin.y = -SteprDigit.distance
            anim(duration: easeDuration!, delay: easeShowDelay!, easing: easeDigitChangeEnter!) {
                self.label!.frame.origin.y = 0
            }
            
            
        case .ToUp:
            
            //number is smaller, fade in from above
            self.label!.frame.origin.y = SteprDigit.distance
            anim(duration: easeDuration!, delay: easeShowDelay!, easing: easeDigitChangeEnter!) {
                self.label!.frame.origin.y = 0
            }
            
        default:
            break
        }
        
        
        
        //fade in
        self.alpha = 0
        anim(duration: easeDuration!, delay: easeShowDelay!, easing: easeDigitFadeIn!) {
            self.alpha = 1
        }
    }
    
    
    func hideAnimation (type : Stepr.AnimationType, completeCallback : ((Void)->Void)) {
        
        switch type {
            
        case .ToDown:
            
            //number is bigger, fade out to above
            self.label!.frame.origin.y = 0
            anim(duration: easeDuration!, easing: easeDigitChangeLeave!) {
                self.label!.frame.origin.y = SteprDigit.distance
            }
            
        case .ToUp:
            
            //number is smaller, fade out to below
            self.label!.frame.origin.y = 0
            anim(duration: easeDuration!, easing: easeDigitChangeLeave!) {
                self.label!.frame.origin.y = -SteprDigit.distance
            }
            
        default:
            break
        }
        
        
        //fade out
        self.alpha = 1
        anim(duration: easeDuration!, easing: easeDigitFadeOut!, animation: {
            self.alpha = 0
        }, completion: { finished in
            completeCallback()
        })
        
    }
    
    
}
