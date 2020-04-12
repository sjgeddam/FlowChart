//
//  ResourcesViewController.swift
//  FlowChart-iOSProject
//
//  Created by Abby Krishnan on 3/28/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit

class ResourcesViewController: UIViewController {

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

        self.navigationController!.setNavigationBarHidden(false,animated:false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.setNavigationBarHidden(true,animated:false)

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
