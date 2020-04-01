//
//  CalendarCollectionViewCell.swift
//  FlowChart-iOSProject
//
//  Created by Shannon Radey on 3/30/20.
//  Copyright © 2020 Abby Krishnan. All rights reserved.
//

import UIKit


class CalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var markDate: UIImageView!
    @IBOutlet weak var topRect: UIImageView!
    @IBOutlet weak var bottomRect: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    var month = 1
    var year = 1
    
    let curDateColor = UIColor(red: 245/255, green: 157/255, blue: 53/255, alpha: 0.6)
    let periodDateColor = UIColor(red: 248/255, green: 10/255, blue: 10/255, alpha: 0.7)
    let ovulationDateColor = UIColor(red: 245/255, green: 157/255, blue:53/255, alpha: 1.0)
    let symptomDateColor = UIColor(red: 243/255, green: 248/255, blue: 10/255, alpha: 1.0)

    
    func setDate(date: String, currentDate: Bool, period: Bool, ovulation: Bool, symptom: Bool) {
        if date != "0" {
            dateLabel.text = date
            button.isEnabled = true
            button.tag = Int(date) ?? 0
        } else {
            button.isEnabled = false
            dateLabel.text = " "
        }
        if (currentDate == true) {
            markDate.tintColor = curDateColor
        } else {
            markDate.tintColor = .clear
        }
        topRect.tintColor = .clear
        bottomRect.tintColor = .clear
        if period == true {
            topRect.tintColor = periodDateColor
        } else if ovulation == true {
            topRect.tintColor = ovulationDateColor
        } else if symptom == true {
            topRect.tintColor = symptomDateColor
            return
        }
        if symptom == true {
            bottomRect.tintColor = symptomDateColor
        }
        
    }
}
