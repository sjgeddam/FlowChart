//
//  ViewController.swift
//  FlowChart-iOSProject
//
//  Created by Abby Krishnan on 3/10/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func segueButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToTracker", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

