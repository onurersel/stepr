//
//  ViewController.swift
//  stepr
//
//  Created by Onur Ersel on 21/01/16.
//  Copyright © 2016 Onur Ersel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SteprDelegate {

    var steprNumbers : Stepr?
    var steprMonths : Stepr?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var c : NSLayoutConstraint
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        
        steprNumbers = Stepr(alignment: .Vertical)
        steprNumbers!.upperLimit = 140
        steprNumbers!.lowerLimit = 80
        steprNumbers!.currentNumber = 100
        steprNumbers!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(steprNumbers!)
        
        c = NSLayoutConstraint(item: steprNumbers!, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute:.Width , multiplier: 1, constant: 0)
        self.view.addConstraint(c)
        c = NSLayoutConstraint(item: steprNumbers!, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute:.Height , multiplier: 0.5, constant: 0)
        self.view.addConstraint(c)
        c = NSLayoutConstraint(item: steprNumbers!, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute:.CenterX , multiplier: 1, constant: 0)
        self.view.addConstraint(c)
        c = NSLayoutConstraint(item: steprNumbers!, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute:.CenterY , multiplier: 1, constant: 0)
        self.view.addConstraint(c)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    
    
    
    
    
}

