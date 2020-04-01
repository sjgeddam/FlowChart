//
//  DayOverviewViewController.swift
//  FlowChart-iOSProject
//
//  Created by Shannon Radey on 3/31/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit

//let monthDict = ["january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"]

class DayOverviewViewController: UIViewController {
    var month = 1
    var year = 2020
    var day = 1
    var delegate: UIViewController!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = "\(monthDict[month]) \(day), \(year)"
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
