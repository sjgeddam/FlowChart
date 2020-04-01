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

    var markedDate: UIImageView!
    var prevColor: UIColor!
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        markedDate.tintColor = prevColor
    }

    @IBAction func onClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
