//
//  ViewController.swift
//  SwiftRuntastic
//
//  Created by Timo Schlüter on 29.11.14.
//  Copyright (c) 2014 Timo Schlüter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var myRuntastic: Runtastic = Runtastic()
        myRuntastic.setUsername("E-MAIL")
        myRuntastic.setPassword("PASSWORD")
        myRuntastic.getRuntasticActivities()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

