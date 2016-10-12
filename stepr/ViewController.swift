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
        
        
        steprNumbers = Stepr(alignment: .vertical)
        steprNumbers!.upperLimit = 140
        steprNumbers!.lowerLimit = 80
        steprNumbers!.currentNumber = 100
        steprNumbers!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(steprNumbers!)
        
        c = NSLayoutConstraint(item: steprNumbers!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute:.width , multiplier: 0.7, constant: 0)
        self.view.addConstraint(c)
        c = NSLayoutConstraint(item: steprNumbers!, attribute: .height, relatedBy: .equal, toItem: nil, attribute:.notAnAttribute , multiplier: 1, constant: 250)
        self.view.addConstraint(c)
        c = NSLayoutConstraint(item: steprNumbers!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute:.centerX , multiplier: 1, constant: 0)
        self.view.addConstraint(c)
        c = NSLayoutConstraint(item: steprNumbers!, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute:.centerY , multiplier: 1, constant: 0)
        self.view.addConstraint(c)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    
    
    
    
    
}

