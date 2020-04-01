//
//  DayOverviewViewController.swift
//  FlowChart-iOSProject
//
//  Created by Shannon Radey on 3/31/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit

var symptoms = ["bloating", "lower back pain", "mood swings", "low energy", "cramping"]

class DayOverviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var month = 1
    var year = 2020
    var day = 1
    var delegate: UIViewController!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        symptoms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DayOverviewTableViewCell
        cell.setLabel(text: symptoms[indexPath.row])
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
