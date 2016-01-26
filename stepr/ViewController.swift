//
//  ViewController.swift
//  stepr
//
//  Created by Onur Ersel on 21/01/16.
//  Copyright © 2016 Onur Ersel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SteprDelegate {

    var s : Stepr?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        s = Stepr(alignment: .Vertical)
        s!.delegate = self
        s!.upperLimit = 10
        //s!.currentNumber = 12
        s!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(s!)
        
        var c = NSLayoutConstraint(item: s!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute:.NotAnAttribute , multiplier: 1, constant: 50)
        self.view.addConstraint(c)
        c = NSLayoutConstraint(item: s!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute:.NotAnAttribute , multiplier: 1, constant: 200)
        self.view.addConstraint(c)
        
        
        c = NSLayoutConstraint(item: s!, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute:.Left , multiplier: 1, constant: 50)
        self.view.addConstraint(c)
        c = NSLayoutConstraint(item: s!, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute:.Top , multiplier: 1, constant: 50)
        self.view.addConstraint(c)
        
        
        //NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "test", userInfo: nil, repeats: false)
    }


    @objc func test () {
        let months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
        s!.dataArray = months
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    
    
    
    
    
}

