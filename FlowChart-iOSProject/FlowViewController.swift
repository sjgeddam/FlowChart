//
//  FlowViewController.swift
//  FlowChart-iOSProject
//
//  Created by Soujanya Geddam on 03/30/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit

class FlowViewController: UIViewController {
    
    
    @IBAction func onDiscard(_ sender: Any) {
        //dismiss immediately
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSave(_ sender: Any) {
        //need to save data first and then dismiss
        //for now, I am dismissing immediately since core data is not yet enabled
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
